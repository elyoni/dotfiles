# Nushell Configuration

Modern shell with structured data and powerful features.

## Quick Install

```bash
cd ~/.dotfiles/applications/nushell
./install install
```

This will:
1. Install Rust (if not present)
2. Install Nushell via cargo
3. Install optional dependencies (fd, ripgrep, bat, fzf, etc.)
4. Setup configuration files

## Installation Options

### Full Install (recommended)
```bash
./install install
```

### Install Only Nushell
```bash
./install install_nushell
```

### Install Only Config
```bash
./install setup_config
```

### Install Dependencies Only
```bash
./install install_packages
```

## Verify Installation

```bash
./install verify
```

## Update Nushell

```bash
./install update
```

## What's Included

### Configuration Files

- **config.nu** - Main configuration with:
  - Fuzzy completion (native)
  - Git helpers
  - Starship prompt integration
  - Keybindings (Ctrl+R, Ctrl+T, Ctrl+G)
  - Native fuzzy utilities (ff, fc, vf, etc.)

- **env.nu** - Environment setup:
  - PATH configuration
  - WIMP settings
  - Editor and locale

- **wimp.nu** - Project finder (Where Is My Project)
  - Fuzzy find git repositories
  - Interactive navigation
  - Works with fzf

### Documentation

- **QUICKSTART.md** - Getting started guide
- **WIMP_GUIDE.md** - Project finder documentation

## Features

### Keybindings

| Key | Action |
|-----|--------|
| **Ctrl+R** | History search (Nu + Zsh combined) |
| **Ctrl+T** | Fuzzy file insert |
| **Ctrl+G** | WIMP project finder |
| **Ctrl+L** | Clear screen |
| **Tab** | Smart completion |

### Native Fuzzy Commands

| Command | Description |
|---------|-------------|
| `ff` | Fuzzy find file |
| `fc` | Fuzzy cd directory |
| `vf` | Fuzzy open file in editor |
| `fk` | Fuzzy kill process |
| `fh-all` | Fuzzy history (Nu + Zsh) |
| `git co` | Fuzzy checkout branch |
| `recent` | Open recent files |
| `cdd` | CD to subdirectory |

### Git Commands

| Command | Description |
|---------|-------------|
| `git status-summary` | Quick status overview |
| `git log-table` | Git log as table |
| `git branches` | List branches |
| `git co` | Fuzzy checkout |
| `git last` | Show last commit |

### WIMP (Project Finder)

```nu
wimp                # Interactive picker (Ctrl+G)
cdp                 # Alias for wimp
wimp list           # List all projects
wimp search rust    # Search projects
wimp goto myapi     # Jump to project
wimp config         # Show settings
```

## Dependencies

### Required
- Rust/Cargo (auto-installed by script)

### Optional (but recommended)
- `fd` - Fast file finder
- `ripgrep` (rg) - Fast grep
- `bat` - Cat with syntax highlighting
- `fzf` - Enhanced fuzzy finder
- `tree` - Directory tree
- `xclip` - Clipboard support
- `starship` - Modern prompt (auto-detected)

## Configuration Location

After installation:
- Config: `~/.config/nushell/`
- Binary: `~/.cargo/bin/nu`

## Usage

### Start Nushell
```bash
nu
```

### Try Features
```nu
# Fuzzy find file
ff

# Change directory with fuzzy search
fc

# Open file in editor
vf

# Project finder
Ctrl+G

# History search (includes zsh history!)
Ctrl+R

# Insert file path
cat <Ctrl+T>
```

## Comparison with Zsh

| Feature | Zsh | Nushell |
|---------|-----|---------|
| Data handling | Text | Structured (tables) |
| Fuzzy finding | fzf | Native + fzf |
| History | Zsh only | Nu + Zsh combined |
| Git info | p10k | Starship |
| Completions | External | Built-in fuzzy |
| Scripting | Bash-like | Modern syntax |

## Uninstall

```bash
./install uninstall
```

This will:
1. Remove nushell binary
2. Backup and remove config
3. Keep dependencies (manually remove if needed)

## Troubleshooting

### "cargo: command not found"
```bash
./install install_rust
source ~/.cargo/env
```

### "nu: command not found" after install
```bash
source ~/.cargo/env
# Or restart shell
```

### Slow Ctrl+R
- Default loads last 2000 commands (fast)
- Use `fh-nu` for nushell-only (fastest)
- Use `fh-full` for all history (slower)

### WIMP not working
Ensure fzf is installed:
```bash
./install install_packages
```

## Advanced

### Change History Limit
Edit `~/.config/nushell/config.nu`:
```nu
def get-zsh-history-fast [limit: int = 5000] {  # Change 2000 to 5000
```

### Use fzf for History
Edit keybinding in config.nu:
```nu
cmd: "fh-fzf"    # Instead of "fh-all"
```

### Custom Commands
Add to `~/.config/nushell/config.nu`:
```nu
def my-command [] {
    # Your code here
}
```

## More Info

- Nushell docs: https://www.nushell.sh/book/
- This config: `~/.config/nushell/QUICKSTART.md`
- WIMP guide: `~/.config/nushell/WIMP_GUIDE.md`

---

**Note:** Installation from cargo takes 10-20 minutes as nushell is built from source.
