#!/usr/bin/env bash
# Remote diagnostic script - run this on the remote server
# Usage: Copy this to remote server and run: bash remote_diagnose.sh

echo "=== Vim Log Syntax Diagnostic (Remote Server) ==="
echo ""

# Check vim installation
echo "1. Checking vim installation..."
if command -v vim >/dev/null 2>&1; then
    echo "   ✓ vim is installed"
    vim --version | head -n 1
    vim_version=$(vim --version | head -n 1 | grep -oE '[0-9]+\.[0-9]+' | head -n 1)
    echo "   Version: $vim_version"
else
    echo "   ✗ vim is not installed"
    exit 1
fi
echo ""

# Check if .vim directory exists
echo "2. Checking .vim directory structure..."
if [[ -d "${HOME}/.vim" ]]; then
    echo "   ✓ ~/.vim directory exists"
else
    echo "   ✗ ~/.vim directory does not exist"
    echo "   Creating it..."
    mkdir -p "${HOME}/.vim/syntax" "${HOME}/.vim/ftdetect"
fi

if [[ -d "${HOME}/.vim/syntax" ]]; then
    echo "   ✓ ~/.vim/syntax directory exists"
else
    echo "   ✗ ~/.vim/syntax directory does not exist"
    mkdir -p "${HOME}/.vim/syntax"
fi

if [[ -d "${HOME}/.vim/ftdetect" ]]; then
    echo "   ✓ ~/.vim/ftdetect directory exists"
else
    echo "   ✗ ~/.vim/ftdetect directory does not exist"
    mkdir -p "${HOME}/.vim/ftdetect"
fi
echo ""

# Check syntax file
echo "3. Checking syntax file..."
syntax_file="${HOME}/.vim/syntax/log.vim"
if [[ -L "$syntax_file" ]]; then
    if [[ -e "$syntax_file" ]]; then
        echo "   ✓ Syntax file symlink exists and is valid"
        echo "     Points to: $(readlink -f "$syntax_file" 2>/dev/null || readlink "$syntax_file")"
        echo "     File size: $(stat -f%z "$syntax_file" 2>/dev/null || stat -c%s "$syntax_file" 2>/dev/null) bytes"
    else
        echo "   ✗ Syntax file symlink is broken"
        echo "     Points to: $(readlink "$syntax_file")"
    fi
elif [[ -f "$syntax_file" ]]; then
    echo "   ⚠ Syntax file exists but is not a symlink"
    echo "     File size: $(stat -f%z "$syntax_file" 2>/dev/null || stat -c%s "$syntax_file" 2>/dev/null) bytes"
else
    echo "   ✗ Syntax file not found at $syntax_file"
fi
echo ""

# Check filetype detection
echo "4. Checking filetype detection..."
ftdetect_file="${HOME}/.vim/ftdetect/log.vim"
if [[ -L "$ftdetect_file" ]]; then
    if [[ -e "$ftdetect_file" ]]; then
        echo "   ✓ Filetype detection symlink exists and is valid"
        echo "     Points to: $(readlink -f "$ftdetect_file" 2>/dev/null || readlink "$ftdetect_file")"
    else
        echo "   ✗ Filetype detection symlink is broken"
        echo "     Points to: $(readlink "$ftdetect_file")"
    fi
elif [[ -f "$ftdetect_file" ]]; then
    echo "   ⚠ Filetype detection exists but is not a symlink"
else
    echo "   ✗ Filetype detection not found at $ftdetect_file"
fi
echo ""

# Check vim runtime path
echo "5. Checking vim runtime path..."
vim_runtime=$(vim -e -c "echo &runtimepath" -c "q" 2>/dev/null | head -n 1)
if [[ -n "$vim_runtime" ]]; then
    echo "   Runtime path includes:"
    echo "$vim_runtime" | tr ',' '\n' | grep -E "(vim|\.vim)" | head -5 | sed 's/^/     /'
    
    # Check if ~/.vim is in runtimepath
    if echo "$vim_runtime" | grep -q "${HOME}/.vim\|\.vim"; then
        echo "   ✓ ~/.vim is in runtime path"
    else
        echo "   ⚠ ~/.vim might not be in runtime path"
    fi
else
    echo "   ⚠ Could not determine runtime path"
fi
echo ""

# Test syntax loading
echo "6. Testing syntax file loading..."
test_file=$(mktemp)
cat > "$test_file" << 'TESTLOG'
2025-12-14T10:38:21.447698+00:00 AutoTransceiver2 overseer (573.888899)(35168.139784341157440):INFO:Test message
2025-12-14T10:38:21.447698+00:00 AutoTransceiver2 overseer (573.888899)(35168.139784341157440):ERROR:Test error
2025-12-14T10:38:21.447698+00:00 AutoTransceiver2 overseer (573.888899)(35168.139784341157440):WARNING:Test warning
TESTLOG

vim_output=$(vim -R -c "set filetype=log" -c "syntax on" -c "redir > /tmp/vim_test_output.txt" -c "echo 'Filetype: ' . &filetype" -c "echo 'Syntax: ' . (exists('b:current_syntax') ? b:current_syntax : 'not set')" -c "redir END" -c "q" "$test_file" 2>&1)

if [[ -f /tmp/vim_test_output.txt ]]; then
    echo "   Vim output:"
    cat /tmp/vim_test_output.txt | sed 's/^/     /'
    rm -f /tmp/vim_test_output.txt
fi

if echo "$vim_output" | grep -q "log\|syntax"; then
    echo "   ✓ Syntax appears to be loading"
else
    echo "   ✗ Syntax might not be loading correctly"
    echo "   Raw output:"
    echo "$vim_output" | head -5 | sed 's/^/     /'
fi

rm -f "$test_file"
echo ""

# Check for syntax errors
echo "7. Checking for syntax errors..."
if [[ -f "$syntax_file" ]] || [[ -L "$syntax_file" ]]; then
    vim_errors=$(vim -e -c "source $syntax_file" -c "q" 2>&1 | grep -iE "(error|warning)" | head -10)
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

# Check file permissions
echo "8. Checking file permissions..."
if [[ -e "$syntax_file" ]]; then
    ls -la "$syntax_file" | sed 's/^/     /'
fi
if [[ -e "$ftdetect_file" ]]; then
    ls -la "$ftdetect_file" | sed 's/^/     /'
fi
echo ""

echo "=== Diagnostic Complete ==="
echo ""
echo "If files are missing, run the installation script again."
echo "If symlinks are broken, check the source files exist."











