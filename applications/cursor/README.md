# Cursor Configuration

This directory contains Cursor IDE configuration files that are version-controlled in the dotfiles repository.

## Structure

```
cursor/
├── install              # Installation script
├── settings.json        # Editor settings
├── keybindings.json     # Custom keybindings
├── snippets/            # Code snippets directory
├── extensions.txt       # List of installed extensions
└── README.md           # This file
```

## Installation

### Initial Setup

To set up Cursor configuration from dotfiles:

```bash
cd ~/.dotfiles/applications/cursor
./install install
```

This will:
1. Create symlinks from `~/.config/Cursor/User/` to the dotfiles
2. Optionally install extensions from `extensions.txt`

### Link Files Only

To only create symlinks without installing extensions:

```bash
./install link_files
```

### Install Extensions

To install extensions from the list:

```bash
./install install_extensions
```

## Maintenance

### Update Configuration Files

Since the Cursor configuration files are symlinked to dotfiles, any changes you make in Cursor will automatically be reflected in the dotfiles repository. Just commit and push the changes:

```bash
cd ~/.dotfiles
git add applications/cursor/
git commit -m "Update Cursor configuration"
git push
```

### Update Extensions List

To update the `extensions.txt` file with currently installed extensions:

```bash
cd ~/.dotfiles/applications/cursor
./install export_extensions
```

### Backup Current Config

To manually backup current Cursor configuration to dotfiles:

```bash
cd ~/.dotfiles/applications/cursor
./install backup_current_config
```

## Verification

To verify that symlinks are correctly set up:

```bash
cd ~/.dotfiles/applications/cursor
./install verify
```

Expected output:
```
✓ settings.json is correctly symlinked
✓ keybindings.json is correctly symlinked
✓ snippets is correctly symlinked
```

## Available Functions

To see all available functions:

```bash
cd ~/.dotfiles/applications/cursor
./install help
```

## Configuration Details

### Settings

The `settings.json` file contains:
- Window and UI preferences
- Neovim integration settings
- Remote SSH configuration
- Editor behavior settings

### Keybindings

Custom keybindings include:
- `Ctrl+I` - Switch to Cursor Composer Agent mode
- `Ctrl+N` - Toggle file explorer
- `, f b` - Neovim send command

### Extensions

Extensions are listed in `extensions.txt` and include:
- Neovim integration (asvetliakov.vscode-neovim)
- Language support (Go, Python)
- Git worktree manager
- Docker tools
- PlantUML support
- And more...

## Notes

- Configuration files are symlinked, so changes in Cursor are immediately reflected in dotfiles
- The snippets directory is ready for custom code snippets
- Extensions can be managed through the Cursor UI or via the install script
