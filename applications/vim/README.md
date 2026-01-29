# Vim Log Syntax Highlighting

Portable vim syntax highlighting for log files with enhanced patterns.

## Quick Start

### Remote Installation (Recommended)

If you only use this on remote servers:

```bash
cd ~/.dotfiles/applications/vim
./install_remote.sh user@example.com
```

**Options:**
```bash
# With custom SSH port
./install_remote.sh -p 2222 user@example.com

# With SSH key
./install_remote.sh -i ~/.ssh/id_rsa user@example.com

# Verify installation
./install_remote.sh verify user@example.com
```

### Local Installation

If you want to install locally:

```bash
cd ~/.dotfiles/applications/vim
./install install
```

## Features

- **Log Levels**: ERROR (red), WARNING (yellow), INFO (cyan), DEBUG, SUCCESS
- **Module Colors**: Different colors for overseer, monitor, stderr, etc.
- **Patterns**: Dates, IPs, MACs, UUIDs, file paths, URLs, stack traces, exceptions
- **Portable**: Works on any server with Vim 8.2+

## Usage

After installation, simply open log files in vim:

```bash
vim /var/log/messages.log
vim /path/to/application.log
```

The syntax highlighting will automatically activate.

### Using tailog (if installed)

```bash
# Follow mode (like tail -f with syntax highlighting)
tailog /var/log/messages.log

# Last 100 lines
tailog -n 100 /var/log/messages.log
```

## Troubleshooting

### Syntax not showing after reboot

Run the fix script:
```bash
cd ~/.dotfiles/applications/vim
./fix_symlinks.sh
```

### Diagnose issues

```bash
cd ~/.dotfiles/applications/vim
./diagnose.sh
```

### Manual verification

Check if files are linked correctly:
```bash
ls -la ~/.vim/syntax/log.vim
ls -la ~/.vim/ftdetect/log.vim
```

Test syntax:
```bash
vim -c "set filetype=log" -c "syntax on" /path/to/test.log
```

## Files

- `syntax/log.vim` - Syntax highlighting definitions
- `ftdetect/log.vim` - Filetype detection rules
- `tail-log.sh` - Enhanced tail with syntax highlighting
- `install` - Local installation script
- `install_remote.sh` - Remote installation script
- `fix_symlinks.sh` - Fix broken symlinks
- `diagnose.sh` - Diagnostic tool

## Remote Installation Details

The `install_remote.sh` script:

1. Tests SSH connection
2. Creates temporary directory on remote
3. Copies syntax files, filetype detection, tail-log.sh, and install script
4. Runs installation on remote host
5. Cleans up temporary files
6. Verifies installation

**Requirements:**
- SSH access to remote host
- `rsync` installed locally
- `vim` installed on remote host (8.2+ recommended)

## Color Scheme

- **ERROR**: Red, bold
- **WARNING**: Yellow, bold  
- **INFO**: Cyan
- **DEBUG**: Comment color
- **SUCCESS**: String color
- **Modules**: 
  - overseer: Yellow
  - monitor: Green
  - stderr (errors): Red
  - stderr (info): Cyan
  - common: Blue











