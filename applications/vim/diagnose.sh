#!/usr/bin/env bash
# Diagnostic script for vim log syntax highlighting

echo "=== Vim Log Syntax Diagnostic ==="
echo ""

# Check vim installation
echo "1. Checking vim installation..."
if command -v vim >/dev/null 2>&1; then
    echo "   ✓ vim is installed"
    vim --version | head -n 1
else
    echo "   ✗ vim is not installed"
    exit 1
fi
echo ""

# Check symlinks
echo "2. Checking symlinks..."
syntax_link="${HOME}/.vim/syntax/log.vim"
ftdetect_link="${HOME}/.vim/ftdetect/log.vim"

if [[ -L "$syntax_link" ]]; then
    if [[ -e "$syntax_link" ]]; then
        echo "   ✓ Syntax file symlink exists and is valid"
        echo "     Points to: $(readlink -f "$syntax_link")"
    else
        echo "   ✗ Syntax file symlink is broken"
        echo "     Points to: $(readlink "$syntax_link")"
    fi
else
    if [[ -f "$syntax_link" ]]; then
        echo "   ⚠ Syntax file exists but is not a symlink"
    else
        echo "   ✗ Syntax file not found"
    fi
fi

if [[ -L "$ftdetect_link" ]]; then
    if [[ -e "$ftdetect_link" ]]; then
        echo "   ✓ Filetype detection symlink exists and is valid"
        echo "     Points to: $(readlink -f "$ftdetect_link")"
    else
        echo "   ✗ Filetype detection symlink is broken"
        echo "     Points to: $(readlink "$ftdetect_link")"
    fi
else
    if [[ -f "$ftdetect_link" ]]; then
        echo "   ⚠ Filetype detection exists but is not a symlink"
    else
        echo "   ✗ Filetype detection not found"
    fi
fi
echo ""

# Check vim runtime path
echo "3. Checking vim runtime path..."
vim_runtime=$(vim -e -c "echo &runtimepath" -c "q" 2>/dev/null | head -n 1)
if [[ -n "$vim_runtime" ]]; then
    echo "   Runtime path includes:"
    echo "$vim_runtime" | tr ',' '\n' | grep -E "(vim|\.vim)" | head -5 | sed 's/^/     /'
fi
echo ""

# Test syntax loading
echo "4. Testing syntax file loading..."
test_file=$(mktemp)
echo "2025-12-14T10:38:21.447698+00:00 AutoTransceiver2 overseer (573.888899)(35168.139784341157440):INFO:Test message" > "$test_file"
echo "2025-12-14T10:38:21.447698+00:00 AutoTransceiver2 overseer (573.888899)(35168.139784341157440):ERROR:Test error" >> "$test_file"
echo "2025-12-14T10:38:21.447698+00:00 AutoTransceiver2 overseer (573.888899)(35168.139784341157440):WARNING:Test warning" >> "$test_file"

vim_output=$(vim -R -c "set filetype=log" -c "syntax on" -c "redir > /dev/stdout" -c "echo 'Filetype: ' . &filetype" -c "echo 'Syntax: ' . b:current_syntax" -c "redir END" -c "q" "$test_file" 2>&1)

if echo "$vim_output" | grep -q "log"; then
    echo "   ✓ Syntax filetype detected correctly"
    echo "$vim_output" | grep -E "(Filetype|Syntax)" | sed 's/^/     /'
else
    echo "   ✗ Syntax filetype not detected"
    echo "$vim_output" | head -5 | sed 's/^/     /'
fi

rm -f "$test_file"
echo ""

# Check for syntax errors
echo "5. Checking for syntax errors..."
syntax_file="${HOME}/.vim/syntax/log.vim"
if [[ -f "$syntax_file" ]] || [[ -L "$syntax_file" ]]; then
    vim_errors=$(vim -e -c "source $syntax_file" -c "q" 2>&1 | grep -i error)
    if [[ -z "$vim_errors" ]]; then
        echo "   ✓ No syntax errors found"
    else
        echo "   ✗ Syntax errors found:"
        echo "$vim_errors" | sed 's/^/     /'
    fi
else
    echo "   ✗ Cannot check - syntax file not found"
fi
echo ""

echo "=== Diagnostic Complete ==="
echo ""
echo "If symlinks are broken, run:"
echo "  cd ~/.dotfiles/applications/vim && ./install install"











