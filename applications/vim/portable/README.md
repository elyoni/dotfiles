# Portable Vim Package

A self-contained vim/neovim package with log syntax highlighting that can be easily copied to any server.

## Quick Start

### 1. Build the Package

```bash
cd ~/.dotfiles/applications/vim/portable
./build_portable.sh --neovim-appimage
```

This creates a `portable_vim_*.tar.gz` file containing:
- Neovim AppImage (portable, no dependencies)
- Log syntax highlighting files
- tailog script
- Installation script

### 2. Deploy to Server

**Option A: Using deploy script (recommended)**
```bash
./deploy_to_server.sh portable_vim_*.tar.gz user@server.com
```

**Option B: Manual deployment**
```bash
# Copy to server
scp portable_vim_*.tar.gz user@server.com:/tmp/

# SSH and install
ssh user@server.com
cd /tmp
tar xzf portable_vim_*.tar.gz
cd portable_vim
./install.sh
```

## What's Included

- **Neovim AppImage** - Portable vim-like editor, no installation needed
- **Log Syntax Files** - Your custom log syntax highlighting
- **tailog Script** - Enhanced tail with syntax highlighting
- **Installation Script** - Easy setup on remote server

## Usage on Server

After installation:

```bash
# Use vim normally
vim /var/log/messages.log

# Use tailog for following logs
tailog /var/log/messages.log
tailog -n 100 /var/log/messages.log
```

## Package Contents

```
portable_vim/
├── bin/
│   ├── vim          # Portable Neovim binary
│   └── tailog       # Enhanced tail script
├── share/
│   └── vim/
│       ├── syntax/
│       │   └── log.vim    # Log syntax highlighting
│       └── ftdetect/
│           └── log.vim     # Filetype detection
├── install.sh       # Installation script
└── README.md        # This file
```

## Installation Locations

The installer creates:
- `~/.local/portable_vim/` - Package files
- `~/.local/bin/vim` - Vim wrapper script
- `~/.local/bin/vi` - Symlink to vim
- `~/.vim/syntax/log.vim` - Syntax file (if ~/.vim exists)
- `~/.vim/ftdetect/log.vim` - Filetype detection (if ~/.vim exists)

## Requirements

**On your local machine (for building):**
- curl (to download Neovim AppImage)
- tar, gzip

**On remote server:**
- None! The package is self-contained
- Just needs basic shell (bash/sh)

## Advantages

✅ **No dependencies** - Works on any Linux server  
✅ **No installation** - Just extract and run  
✅ **Portable** - Single tarball, easy to copy  
✅ **Self-contained** - Includes everything needed  
✅ **Syntax highlighting** - Your custom log syntax included  

## Building Options

```bash
# Use Neovim AppImage (recommended, most portable)
./build_portable.sh --neovim-appimage

# Use local Neovim if it's static (if available)
./build_portable.sh --neovim-static
```

## Deployment Options

```bash
# Basic deployment
./deploy_to_server.sh package.tar.gz user@server.com

# With custom SSH port
./deploy_to_server.sh -p 2222 package.tar.gz user@server.com

# With SSH key
./deploy_to_server.sh -i ~/.ssh/id_rsa package.tar.gz user@server.com
```

## Standalone Usage

You can also use the package without installation:

```bash
# Extract package
tar xzf portable_vim_*.tar.gz
cd portable_vim

# Run vim directly
./bin/vim -u NONE -c "set runtimepath+=./share/vim" /path/to/log.log
```

## Troubleshooting

**Vim not found after installation:**
- Make sure `~/.local/bin` is in your PATH
- Add to `~/.bashrc` or `~/.profile`: `export PATH=$HOME/.local/bin:$PATH`

**Syntax highlighting not working:**
- Check if files exist: `ls -la ~/.vim/syntax/log.vim`
- Test: `vim -c "set filetype=log" /path/to/log.log`

**Package too large:**
- Neovim AppImage is ~50-60MB
- Consider using a static vim build if available (smaller)











