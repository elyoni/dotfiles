# Nushell Environment Configuration

# PATH configuration
$env.PATH = ($env.PATH | split row (char esep) | prepend [
    $"($env.HOME)/.local/bin"
    $"($env.HOME)/.local/go/bin"
    $"($env.HOME)/.cargo/bin"
    "/usr/local/bin"
])

# Editor
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

# Language and locale
$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"

# Colors for ls (using LS_COLORS)
$env.LS_COLORS = "di=1;34:ex=01;32:ln=01;36:so=01;35:pi=33:bd=40;33:cd=40;33;01:su=37;41:sg=30;43:tw=30;42:ow=34;42"

# Less configuration
$env.LESS = "-R"
$env.LESSOPEN = "| /usr/bin/lesspipe %s 2>&-"

# FZF configuration (if you use fzf)
$env.FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border"
$env.FZF_DEFAULT_COMMAND = "fd --type f"

# Ripgrep configuration
$env.RIPGREP_CONFIG_PATH = $"($env.HOME)/.config/ripgrep/config"

# NVM directory (if you use Node Version Manager)
$env.NVM_DIR = $"($env.HOME)/.config/nvm"

# Go configuration
$env.GOPATH = $"($env.HOME)/go"

# Rust/Cargo
$env.CARGO_HOME = $"($env.HOME)/.cargo"

# History file location
$env.HISTFILE = $"($env.HOME)/.config/nushell/history.txt"

# Colorize man pages
$env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"
$env.MANROFFOPT = "-c"

# Custom environment variables
# Add your own environment variables here
# $env.MY_VAR = "value"

# WIMP (Where Is My Project) Configuration
$env.WIMP_EXCLUDE_PATH = [
    '**/yocto-setup/**/*'
    '**/buildroot/dl/'
    '**private/rust_book/'
    '**/buildroot/support'
]
$env.WIMP_PROJECTS_PATH = [
    $"($env.HOME)/private/"
    $"($env.HOME)/projects"
]
$env.WIMP_HISTORY_DIR = $"($env.HOME)/.config/wimp"

# Source machine-specific environment (uncomment and create file if needed)
# Note: In nushell, source is evaluated at parse time, so the file must exist
# Create ~/.config/nushell/local-env.nu if you want machine-specific settings
# source ~/.config/nushell/local-env.nu
