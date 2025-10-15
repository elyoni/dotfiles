# Nushell Configuration
# Enhanced autocomplete and modern shell experience

# Main configuration
$env.config = {
    show_banner: false  # Disable startup banner

    # Enhanced completion settings
    completions: {
        algorithm: "fuzzy"      # Fuzzy matching like fzf
        case_sensitive: false   # Case-insensitive completions
        quick: true            # Show completions quickly
        partial: true          # Complete partial matches
        use_ls_colors: true    # Use LS_COLORS for file completions
    }

    # Line editor settings
    edit_mode: "vi"  # Use vi keybindings (change to "emacs" if you prefer)

    # History settings
    history: {
        max_size: 100000
        sync_on_enter: true
        file_format: "sqlite"  # Better than plaintext
    }

    # Table display
    table: {
        mode: "rounded"        # Nice rounded tables
        index_mode: "auto"
        trim: {
            methodology: "wrapping"
            wrapping_try_keep_words: true
        }
    }

    # File listing colors
    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    # Error handling
    error_style: "fancy"

    # Shell options
    use_ansi_coloring: true
    footer_mode: 25  # Show footer for tables with more than 25 rows
    float_precision: 2

    # Cursor shape
    cursor_shape: {
        vi_insert: "line"
        vi_normal: "block"
        emacs: "line"
    }

    # Keybindings
    keybindings: [
        {
            name: "completion_menu"
            modifier: "none"
            keycode: "tab"
            mode: ["vi_insert" "vi_normal" "emacs"]
            event: {
                until: [
                    { send: "menu" name: "completion_menu" }
                    { send: "menunext" }
                ]
            }
        }
        {
            name: "history_search_combined"
            modifier: "control"
            keycode: "char_r"
            mode: ["vi_insert" "vi_normal" "emacs"]
            event: {
                send: "executehostcommand"
                cmd: "fh-all"
            }
        }
        {
            name: "clear_screen"
            modifier: "control"
            keycode: "char_l"
            mode: ["vi_insert" "vi_normal" "emacs"]
            event: { send: "clearscrollback" }
        }
        {
            name: "open_wimp"
            modifier: "control"
            keycode: "char_g"
            mode: ["vi_insert" "vi_normal" "emacs"]
            event: {
                send: "executehostcommand"
                cmd: "wimp"
            }
        }
        {
            name: "fuzzy_file_finder"
            modifier: "control"
            keycode: "char_t"
            mode: ["vi_insert" "vi_normal" "emacs"]
            event: {
                send: "executehostcommand"
                cmd: "fuzzy-insert-file"
            }
        }
    ]

    # Menus (for completion and history)
    menus: [
        {
            name: "completion_menu"
            only_buffer_difference: false
            marker: "| "
            type: {
                layout: "columnar"
                columns: 4
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
        {
            name: "history_menu"
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: "list"
                page_size: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
    ]
}

# Aliases (similar to your zsh setup)
alias ll = ls -l
alias la = ls -la
alias l = ls
alias vim = nvim
alias vi = nvim
alias v = nvim
alias cat = bat  # If you have bat installed, otherwise remove this
alias grep = rg  # Use ripgrep if available
alias find = fd  # Use fd if available
alias ps = procs  # Use procs if available

# Git aliases
alias g = git
alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push
alias gl = git log --oneline
alias gd = git diff

# Directory navigation helpers
def --env cdl [path: string] {
    cd $path
    ls
}

# Quick directory jumps
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..

# Kubernetes shortcuts (if you use kubectl)
alias k = kubectl
alias kgp = kubectl get pods
alias kgs = kubectl get services
alias kgd = kubectl get deployments

# Docker shortcuts (if you use docker)
alias d = docker
alias dc = docker-compose
alias dps = docker ps
alias di = docker images

# Custom prompt (optional - comment out if you prefer default)
# $env.PROMPT_COMMAND = {||
#     $"(ansi green_bold)($env.PWD)(ansi reset) (ansi cyan)❯(ansi reset) "
# }

# Starship prompt integration - shows git branch, status, commits ahead/behind
$env.STARSHIP_SHELL = "nu"
$env.PROMPT_COMMAND = { starship prompt --cmd-duration $env.CMD_DURATION_MS | str trim }
$env.PROMPT_COMMAND_RIGHT = { starship prompt --right --cmd-duration $env.CMD_DURATION_MS | str trim }
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = "::: "

# Custom commands
# Example: Pretty print JSON
def pj [] {
    from json | table --expand
}

# Example: Quick weather check (requires curl)
def weather [city?: string] {
    let location = if ($city | is-empty) { "" } else { $city }
    http get $"https://wttr.in/($location)?format=3"
}

# Git status summary - shows clean/dirty status
def "git status-summary" [] {
    let status_output = (git status --short | lines)
    let branch = (git branch --show-current)

    {
        branch: $branch
        modified: ($status_output | where ($it | str starts-with " M") | length)
        added: ($status_output | where ($it | str starts-with "A") | length)
        deleted: ($status_output | where ($it | str starts-with " D") | length)
        untracked: ($status_output | where ($it | str starts-with "??") | length)
        total_changes: ($status_output | length)
    }
}

# Git log as structured data
def "git log-table" [count: int = 10] {
    git log $"--max-count=($count)" --pretty=format:"%h|%an|%ar|%s"
    | lines
    | parse "{hash}|{author}|{when}|{message}"
}

# Show git branches with info
def "git branches" [] {
    git branch -vv
    | lines
    | each { |line|
        let is_current = ($line | str starts-with "*")
        let clean_line = ($line | str replace "* " "" | str trim)
        {
            current: $is_current
            info: $clean_line
        }
    }
}

# Quick commit with message
def "gc" [message: string] {
    git add .
    git commit -m $message
}

# Show what changed in last commit
def "git last" [] {
    git log -1 --stat
}

# === History Integration with Zsh ===

# Fast: Read only recent zsh history (last 2000 commands for speed)
def get-zsh-history-fast [limit: int = 2000] {
    if ("~/.zhistory" | path exists) {
        open --raw ~/.zhistory
        | decode utf-8
        | lines
        | reverse  # Most recent first
        | first $limit
        | each { |line|
            # Zsh history format: ": timestamp:duration;command" or just "command"
            if ($line | str starts-with ": ") {
                $line | parse --regex '^:\s*\d+:\d+;(?<cmd>.*)$' | get cmd.0?
            } else {
                $line
            }
        }
        | where ($it | is-not-empty)
    } else {
        []
    }
}

# Fast combined history (recent commands only)
def get-combined-history-fast [] {
    let nu_history = (history | get command | reverse | first 1000)
    let zsh_history = (get-zsh-history-fast 1000)

    $nu_history | append $zsh_history | uniq
}

# FAST: Fuzzy history search (Ctrl+R) - Only recent commands for speed
def --env fh-all [] {
    let cmd = (
        get-combined-history-fast
        | input list --fuzzy "History (last 2000 from Nu + Zsh):"
    )

    if ($cmd | is-not-empty) {
        commandline edit --replace $cmd
    }
}

# FULL: Search all history (slower, but comprehensive) - use manually
def --env fh-full [] {
    let cmd = (
        history | get command
        | append (
            if ("~/.zhistory" | path exists) {
                open --raw ~/.zhistory
                | decode utf-8
                | lines
                | each { |line|
                    if ($line | str starts-with ": ") {
                        $line | parse --regex '^:\s*\d+:\d+;(?<cmd>.*)$' | get cmd.0?
                    } else {
                        $line
                    }
                }
                | where ($it | is-not-empty)
            } else {
                []
            }
        )
        | uniq
        | reverse
        | input list --fuzzy "Full history (all Nu + Zsh):"
    )

    if ($cmd | is-not-empty) {
        commandline edit --replace $cmd
    }
}

# FASTEST: Only nushell history (no file I/O)
def --env fh-nu [] {
    let cmd = (
        history
        | get command
        | reverse
        | uniq
        | input list --fuzzy "Nushell history:"
    )

    if ($cmd | is-not-empty) {
        commandline edit --replace $cmd
    }
}

# ALTERNATIVE: Use external fzf for real-time streaming (like zsh)
# Fastest for very large histories - streams data to fzf
def --env fh-fzf [] {
    if (which fzf | is-empty) {
        print "fzf not installed, falling back to native"
        fh-all
        return
    }

    let cmd = (
        history
        | get command
        | append (
            if ("~/.zhistory" | path exists) {
                open --raw ~/.zhistory
                | decode utf-8
                | lines
                | each { |line|
                    if ($line | str starts-with ": ") {
                        $line | parse --regex '^:\s*\d+:\d+;(?<cmd>.*)$' | get cmd.0?
                    } else {
                        $line
                    }
                }
                | where ($it | is-not-empty)
            } else {
                []
            }
        )
        | uniq
        | reverse
        | to text
        | fzf --height 40% --reverse --tac --no-sort
        | str trim
    )

    if ($cmd | is-not-empty) {
        commandline edit --replace $cmd
    }
}

# === Ctrl+T: Fuzzy file finder that inserts into commandline ===

# Insert file path into command line (like fzf Ctrl+T)
def --env fuzzy-insert-file [] {
    let file = (
        if (which fd | is-not-empty) {
            fd --type f --hidden --exclude .git | lines
        } else if (which fdfind | is-not-empty) {
            fdfind --type f --hidden --exclude .git | lines
        } else {
            glob **/* | where ($it | path type) == file
        }
        | input list --fuzzy "Select file to insert:"
    )

    if ($file | is-not-empty) {
        commandline edit --insert $file
    }
}

# === Native Nushell Fuzzy Utilities (using input list --fuzzy) ===

# Fuzzy find file - 100% NATIVE (no external deps!)
def --env ff [] {
    let file = (
        glob **/*
        | where ($it | path type) == file
        | input list --fuzzy "Select file:"
    )

    if ($file | is-not-empty) {
        print $file
        $file
    }
}

# Fuzzy find file (fast version using fd if available)
def --env fff [] {
    let file = (
        if (which fd | is-not-empty) {
            fd --type f --hidden --exclude .git | lines
        } else if (which fdfind | is-not-empty) {
            fdfind --type f --hidden --exclude .git | lines
        } else {
            glob **/* | where ($it | path type) == file
        }
        | input list --fuzzy "Select file:"
    )

    if ($file | is-not-empty) {
        print $file
        $file
    }
}

# Fuzzy find directory and cd into it - 100% NATIVE
def --env fc [] {
    let dir = (
        glob **/*
        | where ($it | path type) == dir
        | input list --fuzzy "Select directory:"
    )

    if ($dir | is-not-empty) {
        cd $dir
        ls
    }
}

# Fuzzy find directory (fast version using fd if available)
def --env fcc [] {
    let dir = (
        if (which fd | is-not-empty) {
            fd --type d --hidden --exclude .git | lines
        } else if (which fdfind | is-not-empty) {
            fdfind --type d --hidden --exclude .git | lines
        } else {
            glob **/* | where ($it | path type) == dir
        }
        | input list --fuzzy "Select directory:"
    )

    if ($dir | is-not-empty) {
        cd $dir
        ls
    }
}

# Fuzzy search command history (native nushell - Ctrl+R already does this!)
def --env fh [] {
    let cmd = (
        history
        | get command
        | reverse
        | uniq
        | input list --fuzzy "Select command:"
    )

    if ($cmd | is-not-empty) {
        print $cmd
        $cmd
    }
}

# Kill process with fuzzy selector (native nushell)
def fk [] {
    let process = (
        ps
        | select pid name cpu mem
        | input list --fuzzy --display name "Select process to kill:"
    )

    if ($process | is-not-empty) {
        let pid = $process.pid
        print $"Killing process ($process.name) (PID: ($pid))..."
        kill -9 $pid
    }
}

# Quick git checkout branch with fuzzy selector (native nushell)
def --env "git co" [] {
    let branch_line = (
        git branch --all
        | lines
        | each { |b| $b | str replace "* " "" | str trim }
        | input list --fuzzy "Select branch:"
    )

    if ($branch_line | is-not-empty) {
        let branch = ($branch_line | str replace "remotes/origin/" "")
        git checkout $branch
    }
}

# Search and open file in editor - 100% NATIVE
def --env vf [] {
    let file = (
        glob **/*
        | where ($it | path type) == file
        | input list --fuzzy "Select file to edit:"
    )

    if ($file | is-not-empty) {
        nvim $file
    }
}

# Search and open file in editor (fast version with fd)
def --env vff [] {
    let file = (
        if (which fd | is-not-empty) {
            fd --type f --hidden --exclude .git | lines
        } else if (which fdfind | is-not-empty) {
            fdfind --type f --hidden --exclude .git | lines
        } else {
            glob **/* | where ($it | path type) == file
        }
        | input list --fuzzy "Select file to edit:"
    )

    if ($file | is-not-empty) {
        nvim $file
    }
}

# Browse and open recent files - 100% NATIVE
def --env recent [] {
    let file = (
        glob **/*
        | where ($it | path type) == file
        | each { |file|
            {
                path: $file
                modified: (ls $file | get 0.modified)
            }
        }
        | where modified > ((date now) - 7day)
        | sort-by modified --reverse
        | get path
        | input list --fuzzy "Select recent file:"
    )

    if ($file | is-not-empty) {
        nvim $file
    }
}

# List and cd to subdirectories (native nushell)
def --env cdd [] {
    let dir = (
        ls
        | where type == dir
        | get name
        | input list --fuzzy "Select subdirectory:"
    )

    if ($dir | is-not-empty) {
        cd $dir
        ls
    }
}

# Load WIMP (Where Is My Project) - Project finder
source ~/.config/nushell/wimp.nu

# Source additional config (uncomment and create file if needed)
# Note: In nushell, source is evaluated at parse time, so the file must exist
# Create ~/.config/nushell/local.nu if you want machine-specific settings
# source ~/.config/nushell/local.nu
