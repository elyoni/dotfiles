#!/bin/bash

# Script to measure real zsh startup time by opening a terminal window

echo "Testing zsh startup time (real-world scenario)..."
echo "This will open terminal windows and measure startup time"
echo ""

# Method 1: Using gnome-terminal (if available)
if command -v gnome-terminal &> /dev/null; then
    echo "Method 1: Using gnome-terminal"
    for i in {1..3}; do
        echo "Test $i/3:"
        time gnome-terminal --window-with-profile=Default -- zsh -i -c "echo 'Startup complete'; sleep 0.5; exit" 2>&1 | grep real
        sleep 1
    done
    echo ""
fi

# Method 2: Using x-terminal-emulator (generic)
if command -v x-terminal-emulator &> /dev/null; then
    echo "Method 2: Using x-terminal-emulator"
    for i in {1..3}; do
        echo "Test $i/3:"
        time x-terminal-emulator -e zsh -i -c "echo 'Startup complete'; sleep 0.5; exit" 2>&1 | grep real
        sleep 1
    done
    echo ""
fi

# Method 3: More accurate timing using zsh with tty simulation
echo "Method 3: Simulated interactive session"
for i in {1..5}; do
    echo "Test $i/5:"
    # This simulates a more realistic interactive startup
    time script -qec "zsh -i -c 'echo startup_complete; exit'" /dev/null 2>&1 | grep -E "(real|startup_complete)"
done
echo ""

# Method 4: Direct timing with better simulation
echo "Method 4: Direct timing with full initialization"
for i in {1..5}; do
    echo "Test $i/5:"
    time zsh -i -c 'echo "Shell ready"' 2>&1 | grep -E "(real|Shell ready)"
done