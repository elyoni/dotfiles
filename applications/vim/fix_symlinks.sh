#!/usr/bin/env bash
# Fix broken symlinks after reboot or path changes

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "$DIR" && pwd)

echo "=== Fixing Vim Log Syntax Symlinks ==="
echo ""

# Remove broken symlinks
if [[ -L "${HOME}/.vim/syntax/log.vim" ]] && [[ ! -e "${HOME}/.vim/syntax/log.vim" ]]; then
    echo "Removing broken syntax symlink..."
    rm -f "${HOME}/.vim/syntax/log.vim"
fi

if [[ -L "${HOME}/.vim/ftdetect/log.vim" ]] && [[ ! -e "${HOME}/.vim/ftdetect/log.vim" ]]; then
    echo "Removing broken filetype detection symlink..."
    rm -f "${HOME}/.vim/ftdetect/log.vim"
fi

if [[ -L "${HOME}/.local/bin/tailog" ]] && [[ ! -e "${HOME}/.local/bin/tailog" ]]; then
    echo "Removing broken tailog symlink..."
    rm -f "${HOME}/.local/bin/tailog"
fi

# Recreate symlinks
echo "Recreating symlinks..."
mkdir -p "${HOME}/.vim/syntax"
mkdir -p "${HOME}/.vim/ftdetect"
mkdir -p "${HOME}/.local/bin"

ln -sf "${DIR}/syntax/log.vim" "${HOME}/.vim/syntax/log.vim"
ln -sf "${DIR}/ftdetect/log.vim" "${HOME}/.vim/ftdetect/log.vim"

if [[ -f "${DIR}/tail-log.sh" ]]; then
    ln -sf "${DIR}/tail-log.sh" "${HOME}/.local/bin/tailog"
    chmod +x "${DIR}/tail-log.sh"
fi

echo ""
echo "=== Symlinks Fixed ==="
echo ""
echo "Verifying..."
if [[ -L "${HOME}/.vim/syntax/log.vim" ]] && [[ -e "${HOME}/.vim/syntax/log.vim" ]]; then
    echo "✓ Syntax file symlink is valid"
else
    echo "✗ Syntax file symlink failed"
fi

if [[ -L "${HOME}/.vim/ftdetect/log.vim" ]] && [[ -e "${HOME}/.vim/ftdetect/log.vim" ]]; then
    echo "✓ Filetype detection symlink is valid"
else
    echo "✗ Filetype detection symlink failed"
fi

if [[ -L "${HOME}/.local/bin/tailog" ]] && [[ -e "${HOME}/.local/bin/tailog" ]]; then
    echo "✓ tailog script symlink is valid"
else
    echo "⚠ tailog script symlink not found (optional)"
fi











