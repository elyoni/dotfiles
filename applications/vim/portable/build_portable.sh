#!/usr/bin/env bash
# Build portable vim package with log syntax highlighting
# This creates a self-contained package that can be copied to any server

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "$DIR" && pwd)
DOTFILES_DIR=$(cd -P "$DIR/../../.." && pwd)
BUILD_DIR="${DIR}/portable_vim"
PACKAGE_NAME="portable_vim_$(date +%Y%m%d_%H%M%S).tar.gz"

function _usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    --neovim-appimage    Use Neovim AppImage (recommended, portable)
    --neovim-static      Use Neovim static binary (if available)
    --vim-static         Use Vim static binary (if available)
    --help               Show this help

This script creates a portable vim package with:
  - Vim/Neovim binary (portable)
  - Log syntax highlighting files
  - tail-log.sh script
  - Installation script

The package can be copied to any server and extracted.
EOF
}

function _download_neovim_appimage() {
    local version="${1:-latest}"
    local download_dir="${BUILD_DIR}/download"
    mkdir -p "$download_dir"
    
    echo "Downloading Neovim AppImage..."
    
    if [[ "$version" == "latest" ]]; then
        # Get latest version from GitHub API
        local latest_url
        latest_url=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -oP '"browser_download_url": "\K[^"]*nvim.*\.appimage' | head -1)
        
        if [[ -z "$latest_url" ]]; then
            echo "Error: Could not determine latest Neovim version" >&2
            return 1
        fi
        
        echo "Latest version URL: $latest_url"
        curl -L -o "${download_dir}/nvim.appimage" "$latest_url"
    else
        local url="https://github.com/neovim/neovim/releases/download/v${version}/nvim.appimage"
        curl -L -o "${download_dir}/nvim.appimage" "$url"
    fi
    
    chmod +x "${download_dir}/nvim.appimage"
    
    # Test it works
    if "${download_dir}/nvim.appimage" --version >/dev/null 2>&1; then
        echo "✓ Neovim AppImage downloaded and verified"
        return 0
    else
        echo "Error: Neovim AppImage verification failed" >&2
        return 1
    fi
}

function _check_local_neovim() {
    if command -v nvim >/dev/null 2>&1; then
        local nvim_path
        nvim_path=$(command -v nvim)
        echo "Found local Neovim: $nvim_path"
        
        # Check if it's a static binary or can be copied
        if file "$nvim_path" | grep -q "ELF.*statically linked\|AppImage"; then
            echo "✓ Neovim appears to be portable"
            cp "$nvim_path" "${BUILD_DIR}/nvim"
            chmod +x "${BUILD_DIR}/nvim"
            return 0
        else
            echo "⚠ Neovim is dynamically linked, may need libraries"
            return 1
        fi
    fi
    return 1
}

function _build_package() {
    local editor_type="$1"
    local editor_binary="$2"
    
    echo "=== Building Portable Vim Package ==="
    echo ""
    
    # Clean and create build directory
    rm -rf "$BUILD_DIR"
    mkdir -p "${BUILD_DIR}/vim_runtime"
    mkdir -p "${BUILD_DIR}/bin"
    mkdir -p "${BUILD_DIR}/share/vim/syntax"
    mkdir -p "${BUILD_DIR}/share/vim/ftdetect"
    
    # Copy editor binary
    if [[ -f "$editor_binary" ]]; then
        cp "$editor_binary" "${BUILD_DIR}/bin/vim"
        chmod +x "${BUILD_DIR}/bin/vim"
        echo "✓ Copied editor binary"
    else
        echo "Error: Editor binary not found: $editor_binary" >&2
        return 1
    fi
    
    # Copy syntax files
    if [[ -f "${DOTFILES_DIR}/applications/vim/syntax/log.vim" ]]; then
        cp "${DOTFILES_DIR}/applications/vim/syntax/log.vim" "${BUILD_DIR}/share/vim/syntax/log.vim"
        echo "✓ Copied syntax file"
    else
        echo "Error: Syntax file not found" >&2
        return 1
    fi
    
    if [[ -f "${DOTFILES_DIR}/applications/vim/ftdetect/log.vim" ]]; then
        cp "${DOTFILES_DIR}/applications/vim/ftdetect/log.vim" "${BUILD_DIR}/share/vim/ftdetect/log.vim"
        echo "✓ Copied filetype detection"
    else
        echo "Error: Filetype detection not found" >&2
        return 1
    fi
    
    # Copy tail-log.sh
    if [[ -f "${DOTFILES_DIR}/applications/vim/tail-log.sh" ]]; then
        cp "${DOTFILES_DIR}/applications/vim/tail-log.sh" "${BUILD_DIR}/bin/tailog"
        chmod +x "${BUILD_DIR}/bin/tailog"
        echo "✓ Copied tailog script"
    fi
    
    # Create installation script
    cat > "${BUILD_DIR}/install.sh" << 'INSTALL_EOF'
#!/usr/bin/env bash
# Installation script for portable vim package

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${INSTALL_DIR:-${HOME}/.local/portable_vim}"

echo "=== Installing Portable Vim ==="
echo ""

# Create installation directory
mkdir -p "$INSTALL_DIR"
mkdir -p "${HOME}/.local/bin"

# Copy files
echo "Copying files..."
cp -r "$SCRIPT_DIR"/* "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/bin/vim"
chmod +x "$INSTALL_DIR/bin/tailog" 2>/dev/null || true

# Create symlinks or wrapper scripts
echo "Creating symlinks..."

# Create vim wrapper that sets runtime path
cat > "${HOME}/.local/bin/vim" << 'VIM_EOF'
#!/usr/bin/env bash
VIM_HOME="${HOME}/.local/portable_vim"
exec "${VIM_HOME}/bin/vim" -u NONE \
    -c "set runtimepath+=${VIM_HOME}/share/vim" \
    -c "set runtimepath+=${HOME}/.vim" \
    "$@"
VIM_EOF

chmod +x "${HOME}/.local/bin/vim"

# Create vi alias
ln -sf "${HOME}/.local/bin/vim" "${HOME}/.local/bin/vi" 2>/dev/null || true

# Install syntax files to ~/.vim if it exists
if [[ -d "${HOME}/.vim" ]]; then
    echo "Installing syntax files to ~/.vim..."
    mkdir -p "${HOME}/.vim/syntax"
    mkdir -p "${HOME}/.vim/ftdetect"
    cp "${INSTALL_DIR}/share/vim/syntax/log.vim" "${HOME}/.vim/syntax/log.vim"
    cp "${INSTALL_DIR}/share/vim/ftdetect/log.vim" "${HOME}/.vim/ftdetect/log.vim"
    echo "✓ Syntax files installed"
fi

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Vim is now available at: ${HOME}/.local/bin/vim"
echo "Make sure ${HOME}/.local/bin is in your PATH"
echo ""
echo "Usage:"
echo "  vim /path/to/logfile.log"
echo "  tailog /path/to/logfile.log"
INSTALL_EOF

    chmod +x "${BUILD_DIR}/install.sh"
    echo "✓ Created installation script"
    
    # Create README
    cat > "${BUILD_DIR}/README.md" << 'README_EOF'
# Portable Vim Package

This is a self-contained vim package with log syntax highlighting.

## Installation

1. Extract the package:
   ```bash
   tar xzf portable_vim_*.tar.gz
   cd portable_vim
   ```

2. Run installation:
   ```bash
   ./install.sh
   ```

Or install to a custom location:
   ```bash
   INSTALL_DIR=/opt/portable_vim ./install.sh
   ```

## Usage

After installation, use vim normally:
```bash
vim /var/log/messages.log
```

The log syntax highlighting will work automatically.

## Manual Installation

If you prefer manual installation:

1. Copy `bin/vim` to a directory in your PATH
2. Copy `share/vim/syntax/log.vim` to `~/.vim/syntax/`
3. Copy `share/vim/ftdetect/log.vim` to `~/.vim/ftdetect/`

## Standalone Usage

You can also use vim directly from the package:
```bash
./bin/vim -u NONE -c "set runtimepath+=./share/vim" /path/to/file.log
```

## Contents

- `bin/vim` - Portable vim/neovim binary
- `share/vim/syntax/log.vim` - Log syntax highlighting
- `share/vim/ftdetect/log.vim` - Filetype detection
- `bin/tailog` - Enhanced tail with syntax highlighting
- `install.sh` - Installation script
README_EOF

    echo "✓ Created README"
    echo ""
    
    # Create tarball
    echo "Creating package..."
    cd "$(dirname "$BUILD_DIR")"
    tar czf "${PACKAGE_NAME}" "$(basename "$BUILD_DIR")"
    
    local package_path
    package_path="$(pwd)/${PACKAGE_NAME}"
    local package_size
    package_size=$(du -h "$package_path" | cut -f1)
    
    echo ""
    echo "=== Package Created Successfully ==="
    echo ""
    echo "Package: $package_path"
    echo "Size: $package_size"
    echo ""
    echo "To deploy to a server:"
    echo "  scp $package_path user@server:/tmp/"
    echo "  ssh user@server 'cd /tmp && tar xzf $(basename "$package_path") && cd portable_vim && ./install.sh'"
    echo ""
}

function main() {
    local use_appimage=false
    local use_static=false
    local editor_binary=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --neovim-appimage)
                use_appimage=true
                shift
                ;;
            --neovim-static)
                use_static=true
                shift
                ;;
            --vim-static)
                use_static=true
                shift
                ;;
            --help|-h)
                _usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
                _usage
                exit 1
                ;;
        esac
    done
    
    # Default to AppImage if nothing specified
    if [[ "$use_appimage" == false ]] && [[ "$use_static" == false ]]; then
        use_appimage=true
    fi
    
    # Download or find editor
    if [[ "$use_appimage" == true ]]; then
        if _download_neovim_appimage; then
            editor_binary="${BUILD_DIR}/download/nvim.appimage"
        else
            echo "Error: Failed to download Neovim AppImage" >&2
            exit 1
        fi
    elif [[ "$use_static" == true ]]; then
        if _check_local_neovim; then
            editor_binary="${BUILD_DIR}/nvim"
        else
            echo "Error: Could not find portable Neovim/Vim" >&2
            echo "Try using --neovim-appimage instead" >&2
            exit 1
        fi
    fi
    
    # Build package
    _build_package "neovim" "$editor_binary"
}

main "$@"











