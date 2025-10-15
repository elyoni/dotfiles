# === WIMP - Where Is My Project (Nushell Edition) ===
# Find and navigate to your git projects quickly
#
# Requirements:
# - fzf
# - fd (or fdfind)
# - xclip (for clipboard)
# - tree (for preview)
# - git
#
# Configuration:
# Set these in your env.nu or config.nu:
# $env.WIMP_EXCLUDE_PATH = ['**/yocto-setup/**/*' '**/buildroot/dl/' '**private/rust_book/']
# $env.WIMP_PROJECTS_PATH = [$"($env.HOME)/private/" $"($env.HOME)/projects"]

# Main WIMP function
def --env wimp [] {
    # Get configuration from environment or use defaults
    let exclude_paths = if 'WIMP_EXCLUDE_PATH' in $env {
        $env.WIMP_EXCLUDE_PATH
    } else {
        []
    }

    let projects_paths = if 'WIMP_PROJECTS_PATH' in $env {
        $env.WIMP_PROJECTS_PATH
    } else {
        [$"($env.HOME)/private/" $"($env.HOME)/projects"]
    }

    let history_dir = if 'WIMP_HISTORY_DIR' in $env {
        $env.WIMP_HISTORY_DIR
    } else {
        $"($env.HOME)/.config/wimp"
    }

    # Create history directory if it doesn't exist
    mkdir $history_dir

    # Validate paths exist
    let valid_paths = $projects_paths | where { |path| ($path | path exists) }

    if ($valid_paths | is-empty) {
        print ""
        print " =============== WIMP =============== "
        print "No valid project paths found. Please set WIMP_PROJECTS_PATH"
        print $"Example: $env.WIMP_PROJECTS_PATH = ['($env.HOME)/projects']"
        print " =============== ==== =============== "
        return
    }

    # Determine which fd command to use
    let fd_cmd = if (which fdfind | is-not-empty) {
        "fdfind"
    } else if (which fd | is-not-empty) {
        "fd"
    } else {
        print "Error: fd or fdfind not found. Please install fd-find."
        return
    }

    # Build fd command arguments using reduce
    let base_args = ["--no-ignore" "--type" "directory" "--hidden" "--absolute-path"]

    let search_args = ($valid_paths | reduce -f [] { |path, acc|
        $acc | append ["--search-path" $path]
    })

    let exclude_args = ($exclude_paths | reduce -f [] { |pattern, acc|
        $acc | append ["--exclude" $pattern]
    })

    let fd_args = ($base_args | append $search_args | append $exclude_args | append [".git$"])

    # Execute fd and get parent directories (the actual project dirs)
    let git_dirs = (
        ^$fd_cmd ...$fd_args
        | lines
        | each { |line| $line | path dirname }
        | uniq
    )

    if ($git_dirs | is-empty) {
        print "No git projects found in the specified paths."
        return
    }

    # Prepare fzf command
    let fzf_args = [
        "-m"
        "--height" "30"
        "--header-first"
        "--header" "Keymap: Enter(cd), Ctrl-Y(copy), Ctrl-X(browser), Ctrl-O(file manager)"
        "--border"
        "--border-label=╢ Where is my project! ╟"
        "--info=right"
        "--prompt=🔍 Project>"
        $"--history=($history_dir)/history"
        "--bind" "ctrl-y:execute-silent(echo -n {} | xclip -sel clip)+abort"
        "--bind" "ctrl-c:execute-silent(echo -n {} | xclip -sel clip)+abort"
        "--bind" "ctrl-x:execute-silent(cd {} && git site)+abort"
        "--bind" "ctrl-o:execute-silent(xdg-open {} &)+abort"
        "--bind" "?:preview:echo 'Help: \\n\\tUse arrow keys to navigate\\n\\tEnter to cd into project\\n\\tCtrl-Y or Ctrl-C to copy path\\n\\tCtrl-X to open in browser\\n\\tCtrl-O to open in file manager'"
        "--preview-window=up"
        "--preview" "tree -d -L 1 -C {} | head -200"
    ]

    # Run fzf with project list
    let selected = (
        $git_dirs
        | to text
        | ^fzf ...$fzf_args
        | str trim
    )

    # Change directory if a project was selected
    if ($selected | is-not-empty) {
        cd $selected
        print $"Changed to: ($selected)"
    }
}

# Quick alias for wimp
alias cdp = wimp

# Helper function to search for projects matching a pattern
def --env "wimp search" [pattern: string] {
    let projects_paths = if 'WIMP_PROJECTS_PATH' in $env {
        $env.WIMP_PROJECTS_PATH
    } else {
        [$"($env.HOME)/private/" $"($env.HOME)/projects"]
    }

    let fd_cmd = if (which fdfind | is-not-empty) { "fdfind" } else { "fd" }

    let base_args = ["--no-ignore" "--type" "directory" "--hidden" "--absolute-path"]

    let search_args = ($projects_paths | reduce -f [] { |path, acc|
        $acc | append ["--search-path" $path]
    })

    let fd_args = ($base_args | append $search_args | append [".git$"])

    ^$fd_cmd ...$fd_args
    | lines
    | each { |line| $line | path dirname }
    | uniq
    | where { |proj| ($proj | str contains $pattern) }
    | each { |proj|
        {
            path: $proj
            name: ($proj | path basename)
        }
    }
}

# List all projects
def "wimp list" [] {
    wimp search ""
}

# Quick cd to a project by name (fuzzy match)
def --env "wimp goto" [name: string] {
    let matches = wimp search $name

    if ($matches | is-empty) {
        print $"No projects found matching '($name)'"
        return
    }

    if ($matches | length) == 1 {
        let project = ($matches | first | get path)
        cd $project
        print $"Changed to: ($project)"
    } else {
        print "Multiple matches found:"
        $matches | each { |m| print $"  - ($m.path)" }
        print "\nPlease be more specific or use 'wimp' for interactive selection"
    }
}

# Export WIMP configuration helper
def "wimp config" [] {
    print "Current WIMP Configuration:"
    print ""
    print "Project Paths:"
    if 'WIMP_PROJECTS_PATH' in $env {
        $env.WIMP_PROJECTS_PATH | each { |p| print $"  - ($p)" }
    } else {
        print "  (not set - using defaults)"
    }

    print ""
    print "Exclude Patterns:"
    if 'WIMP_EXCLUDE_PATH' in $env {
        $env.WIMP_EXCLUDE_PATH | each { |p| print $"  - ($p)" }
    } else {
        print "  (not set)"
    }

    print ""
    print "History Directory:"
    if 'WIMP_HISTORY_DIR' in $env {
        print $"  ($env.WIMP_HISTORY_DIR)"
    } else {
        print $"  ($env.HOME)/.config/wimp" ++ " (default)"
    }
}
