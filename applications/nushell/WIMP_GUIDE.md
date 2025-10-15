# WIMP - Where Is My Project (Nushell Edition)

WIMP is a powerful project finder that helps you quickly navigate to your git repositories.

## Quick Start

### Main Command
```nu
wimp                # Interactive project selector with fzf
```

This opens an **interactive fuzzy finder** with all your git projects.

### Keybindings in fzf

| Key | Action |
|-----|--------|
| **Enter** | CD into the selected project |
| **Ctrl+Y** or **Ctrl+C** | Copy project path to clipboard |
| **Ctrl+X** | Open project in browser (runs `git site`) |
| **Ctrl+O** | Open project in file manager |
| **?** | Show help |
| **Arrow keys** | Navigate projects |
| **Esc** | Cancel |

## Additional Commands

### List All Projects
```nu
wimp list           # Show all git projects as a table
```

### Search for Projects
```nu
wimp search rust    # Find projects matching "rust"
wimp search api     # Find projects matching "api"
```

### Quick Goto
```nu
wimp goto myproject     # Jump directly to a project by name
```
If multiple matches, shows list. If exact match, changes directory immediately.

### View Configuration
```nu
wimp config         # Display current WIMP settings
```

## Aliases

For convenience, there's a short alias:
```nu
cdp                 # Same as `wimp`
```

## Configuration

WIMP is configured via environment variables in `~/.config/nushell/env.nu`:

```nu
# Where to search for projects
$env.WIMP_PROJECTS_PATH = [
    $"($env.HOME)/private/"
    $"($env.HOME)/projects"
]

# Paths to exclude from search
$env.WIMP_EXCLUDE_PATH = [
    '**/yocto-setup/**/*'
    '**/buildroot/dl/'
    '**private/rust_book/'
]

# Where to store search history
$env.WIMP_HISTORY_DIR = $"($env.HOME)/.config/wimp"
```

### Customizing Paths

Edit `~/.config/nushell/env.nu` and modify:

```nu
# Add more project directories
$env.WIMP_PROJECTS_PATH = [
    $"($env.HOME)/private/"
    $"($env.HOME)/projects"
    $"($env.HOME)/work"           # Add this
    "/mnt/projects"                # Or this
]

# Exclude large directories
$env.WIMP_EXCLUDE_PATH = [
    '**/node_modules/**/*'         # Skip node_modules
    '**/target/**/*'               # Skip Rust build dirs
    '**/.venv/**/*'                # Skip Python venvs
]
```

## Examples

### Interactive Navigation
```nu
# Launch interactive picker
wimp
# Use arrow keys to find your project
# Press Enter to cd into it
```

### Quick Jump
```nu
# If you know the project name
wimp goto my-api-project

# Fuzzy search
wimp search api    # Shows all projects with "api" in the name
```

### List and Pipe
```nu
# Get all projects as structured data
wimp list

# Filter and manipulate
wimp list | where name =~ "rust"
wimp list | sort-by name
wimp list | select name path
```

### Copy Path Without CD
```nu
# Open wimp, press Ctrl+Y to copy path without changing directory
wimp
```

## Integration with Other Tools

### Open in Editor
```nu
# Find and open project in nvim
wimp
# After selecting, run:
nvim .
```

### Combine with Other Commands
```nu
# List projects and show git status for each
wimp list | each { |proj|
    cd $proj.path
    git status --short
}
```

## Tips & Tricks

### 1. History
WIMP remembers your selections! Recent projects appear first next time you use it.

### 2. Preview
The preview window shows the directory structure using `tree`. Navigate with arrow keys to see different projects.

### 3. Multiple Selection
Press `Tab` in fzf to select multiple projects (though cd only uses the last one).

### 4. Quick Access
Add this to your workflow:
```nu
# In your shell
wimp                    # Opens interactive finder
# Select project
git pull               # Update it
code .                 # Open in VS Code
```

## Requirements

- **fzf**: Fuzzy finder (required)
- **fd** or **fdfind**: Fast file finder (required)
- **xclip**: For clipboard operations (optional)
- **tree**: For directory preview (optional)
- **git**: To detect repositories (required)

Install missing tools:
```bash
# Ubuntu/Debian
sudo apt install fzf fd-find xclip tree git

# Arch
sudo pacman -S fzf fd xclip tree git

# macOS
brew install fzf fd tree git
```

## Troubleshooting

### "No git projects found"
- Check that `WIMP_PROJECTS_PATH` points to valid directories
- Verify directories contain `.git` folders
- Run `wimp config` to see current settings

### "fd or fdfind not found"
- Install fd-find: `sudo apt install fd-find`
- On some systems it's `fd`, on others `fdfind`

### Clipboard doesn't work (Ctrl+Y)
- Install xclip: `sudo apt install xclip`
- For Wayland, you might need `wl-clipboard` instead

### Projects are excluded unexpectedly
- Check `WIMP_EXCLUDE_PATH` patterns
- Run `wimp config` to see exclusion patterns
- Adjust patterns in `~/.config/nushell/env.nu`

## Differences from Zsh Version

### Improvements in Nushell:
✅ Structured output with `wimp list` and `wimp search`
✅ Better data manipulation (filter, sort, pipe)
✅ Type-safe configuration
✅ Cleaner function interface

### Same Features:
✅ Interactive fzf selection
✅ Keyboard shortcuts (Ctrl+Y, Ctrl+X, etc.)
✅ History support
✅ Preview with tree
✅ Exclude paths support

## Advanced Usage

### Custom Scripts
```nu
# Find all Rust projects
def rust-projects [] {
    wimp list
    | where path =~ "rust"
    | each { |proj|
        {
            name: $proj.name
            path: $proj.path
            size: (du -s $proj.path | get 0.physical)
        }
    }
}

# Open all projects in tmux sessions
def tmux-projects [] {
    wimp list
    | each { |proj|
        tmux new-session -d -s $proj.name -c $proj.path
    }
}
```

### Integration with Git
```nu
# Update all projects
def update-all-projects [] {
    wimp list
    | each { |proj|
        cd $proj.path
        print $"Updating ($proj.name)..."
        git pull
    }
}
```

Enjoy your turbocharged project navigation! 🚀
