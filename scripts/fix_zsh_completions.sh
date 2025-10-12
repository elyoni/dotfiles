#!/bin/bash

# Fix zsh completions by clearing stale cache and rebuilding
# Use this when custom completions stop working

echo "🔧 Fixing zsh completions..."

echo "1. Backing up current zcompdump files..."
if ls ~/.zcompdump* &>/dev/null; then
    mkdir -p ~/.zcompdump_backup
    cp ~/.zcompdump* ~/.zcompdump_backup/ 2>/dev/null
    echo "   ✓ Backed up to ~/.zcompdump_backup/"
else
    echo "   ℹ No existing zcompdump files found"
fi

echo "2. Removing stale completion cache..."
rm -f ~/.zcompdump*
echo "   ✓ Cleared completion cache"

echo "3. Testing completion rebuild..."
zsh -c "
    fpath+=(~/.zfunc)
    autoload -Uz compinit
    compinit -C
    echo '   ✓ Rebuilt completion system'

    # Test task completion specifically
    if type _task >/dev/null 2>&1; then
        echo '   ✓ Task completion loaded successfully'
    else
        echo '   ✗ Task completion failed to load'
        exit 1
    fi
"

if [[ $? -eq 0 ]]; then
    echo "✅ Zsh completions fixed successfully!"
    echo "   Start a new shell or run 'exec zsh' to test"
else
    echo "❌ Failed to fix completions"
    echo "   You may need to check your fpath configuration"
    exit 1
fi