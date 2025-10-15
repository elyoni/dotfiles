# Nushell Quick Start Guide

## Starting Nushell
```bash
nu
```

## Key Differences from Zsh/Bash

### 1. Everything is Data (Tables!)
In nushell, commands output **structured data** (tables), not text:

```nu
# Get running processes as a table
ps | where cpu > 5

# Work with files as structured data
ls | where size > 1mb | sort-by modified

# Get git status as structured data
git status | lines | parse "{status} {file}"
```

### 2. Autocomplete is Built-in and Smart
- **Tab completion**: Press `Tab` for file/command completion
- **Fuzzy matching**: Type partial text and tab (e.g., `gc` → `git commit`)
- **Context-aware**: Completions change based on command
- **Ctrl+R**: History search (just like zsh)

### 3. Pipeline Works Differently
Data flows through pipelines as structured objects:

```nu
# Zsh/Bash way:
# ls -l | grep txt | awk '{print $9}'

# Nushell way:
ls | where name =~ txt | get name
```

### 4. No Need for awk/sed/grep
Built-in data manipulation:

```nu
# Filter
ls | where type == file

# Select columns
ps | select pid name cpu

# Sort
ls | sort-by size

# Group
ls | group-by type

# Math
ls | where type == file | get size | math sum
```

## Common Tasks

### File Operations
```nu
# List files
ls
ls -la
ls | where size > 1mb

# Find files
ls **/*.rs  # All Rust files recursively
glob **/*.{rs,toml}  # Multiple extensions

# Copy/move with confirmation
cp file.txt backup/
mv old.txt new.txt
```

### Working with JSON/CSV/YAML
```nu
# Parse JSON
open data.json | get users | where active == true

# Convert to JSON
ls | to json

# Work with CSV
open data.csv | where price > 100 | sort-by price

# YAML
open config.yaml | get database.host
```

### Git Workflow
```nu
# Status
git status

# Stage and commit
git add .
git commit -m "message"

# View log as table
git log --oneline | lines | split column " " commit message
```

### System Monitoring
```nu
# CPU usage
ps | sort-by cpu | reverse | first 10

# Memory usage
ps | sort-by mem | reverse | first 10

# Disk space
df | where filesystem =~ "sd"
```

## Keyboard Shortcuts (Configured)

- `Tab`: Complete current word
- `Ctrl+R`: History search menu
- `Ctrl+L`: Clear screen
- `Ctrl+C`: Cancel current command
- `Ctrl+D`: Exit nushell

## Custom Functions (in config.nu)

### `pj` - Pretty Print JSON
```nu
cat file.json | pj
```

### `weather` - Quick Weather Check
```nu
weather          # Local weather
weather London   # Weather for London
```

### `cdl` - CD and List
```nu
cdl /path/to/dir  # cd and ls in one command
```

## Aliases (Already Configured)

### File Operations
- `ll` → `ls -l`
- `la` → `ls -la`
- `l` → `ls`

### Editor
- `v`, `vi`, `vim` → `nvim`

### Modern Tools (if installed)
- `cat` → `bat` (syntax highlighting)
- `grep` → `rg` (ripgrep)
- `find` → `fd`
- `ps` → `procs`

### Git
- `g` → `git`
- `gs` → `git status`
- `ga` → `git add`
- `gc` → `git commit`
- `gp` → `git push`
- `gl` → `git log --oneline`

### Kubernetes
- `k` → `kubectl`
- `kgp` → `kubectl get pods`
- `kgs` → `kubectl get services`

### Docker
- `d` → `docker`
- `dc` → `docker-compose`
- `dps` → `docker ps`

## Tips and Tricks

### 1. Explore Commands
```nu
help commands  # List all commands
help <command>  # Get help for specific command
```

### 2. Table Manipulation
```nu
# Transpose a table
ps | transpose

# Flatten nested structures
open nested.json | flatten

# Reject columns
ls | reject modified accessed
```

### 3. String Manipulation
```nu
# Split and join
"hello,world" | split row ","
["hello" "world"] | str join ", "

# Case conversion
"HELLO" | str downcase
"hello" | str upcase
```

### 4. Math Operations
```nu
# Simple math
= 1 + 2 * 3

# On table columns
ls | get size | math sum
ls | get size | math avg
```

### 5. Custom Scripts
Create `.nu` files and run them:

```nu
# my-script.nu
def main [name: string] {
    echo $"Hello, ($name)!"
}

# Run it
nu my-script.nu World
```

## Learning Resources

- Official Book: https://www.nushell.sh/book/
- Cookbook: https://www.nushell.sh/cookbook/
- Discord: https://discord.gg/NtAbbGn

## Switching Between Shells

You can use both zsh and nushell!

- **zsh**: Your default shell (stays in `~/.zshrc`)
- **nushell**: Launch with `nu` command when you want structured data power
- **Make nushell default** (optional): `chsh -s $(which nu)`

## Configuration Files

- `~/.config/nushell/config.nu` - Main config (aliases, keybindings, settings)
- `~/.config/nushell/env.nu` - Environment variables and PATH
- `~/.config/nushell/local.nu` - Machine-specific config (sourced if exists)
- `~/.config/nushell/local-env.nu` - Machine-specific env (sourced if exists)

## Customization

Edit your config:
```nu
config nu  # Opens config.nu in your $EDITOR
```

View current settings:
```nu
$env.config | table --expand
```

## Try It Out!

Start nushell and try these:

```nu
# See your processes as a nice table
ps | where cpu > 1

# Find large files
ls **/* | where size > 10mb | sort-by size | reverse

# Work with JSON
http get https://api.github.com/users/octocat | get name

# Quick calculations
= 42 * 1.5 + 10
```

Enjoy your new modern shell! 🚀
