# Dotfiles

Personal dotfiles for Linux development environment.

## System Overview

- **Linux Distribution:** Ubuntu 24.04
- **Window Manager:** Regolith 3 (i3-based)
- **Terminal:** Ghostty
- **Text Editor/IDE:** Neovim
- **Git Interface:** tig
- **File Manager:** Ranger
- **Browser:** Firefox
- **Shell:** Zsh

## Installation

```bash
sudo apt-get install git -y
git clone https://github.com/elyoni/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

The install script provides a menu with 4 options:

### Option 1 - System

- **Desktop Environment:** Regolith 3
- **System Config:** Fonts, Network, SSH
- **Package Systems:** AppImage, Flatpak
- **Hardware TUI:** Bluetui (Bluetooth), Pulsemixer (Audio)

### Option 2 - Programming Languages

- C/C++
- Python (with uv, poetry)
- Node.js
- Go
- Rust

### Option 3 - Terminal Apps

- **Shell:** Zsh, Nushell
- **Editor:** Neovim
- **Multiplexer:** Tmux
- **Terminal:** Ghostty
- **Git Tools:** Git, tig
- **Search:** Ripgrep, Fzf
- **Task Runners:** Task (go-task), Tusk, Taskwarrior
- **Utilities:** Ranger, Cheat, Direnv, Bat, Docker

### Option 4 - GUI Apps

- **Browser:** Firefox
- **Security:** KeePass
- **Screenshot:** Flameshot
- **Communication:** Telegram

## Repository Structure

```
.dotfiles/
├── applications/          # Terminal and GUI applications
├── system/                # System config (WM, fonts, terminal themes)
├── programming-languages/ # Dev environment setup
├── scripts/               # Utility scripts
├── utils/                 # Shared utility functions
└── install_scripts/       # Installation orchestration
```

## Commit Conventions

All commit messages must start with the module name in square brackets:

```
[<module name>] <commit message>
```

The module name should correspond to the top-level directory or specific application being modified. Examples:

- `[neovim] Update keybindings and plugin configurations`
- `[zsh] Add new aliases for kubectl`
- `[system] Update i3 window manager configuration`
- `[scripts] Add log viewer installation script`
- `[python] Update installation script dependencies`
