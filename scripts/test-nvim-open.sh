#!/bin/bash
# Test script to verify nvim-open.sh works

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_FILE="${1:-$SCRIPT_DIR/nvim-open.sh}"

echo "Testing nvim-open.sh with file: $TEST_FILE"
echo "Script location: $SCRIPT_DIR/nvim-open.sh"

if [ -f "$SCRIPT_DIR/nvim-open.sh" ]; then
    bash "$SCRIPT_DIR/nvim-open.sh" "$TEST_FILE"
else
    echo "Error: nvim-open.sh not found at $SCRIPT_DIR/nvim-open.sh"
    exit 1
fi
