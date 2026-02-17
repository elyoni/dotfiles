#!/bin/bash

# Script to open a file in neovim from the project directory
# Usage: nvim-open.sh <file_path>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

FILE_PATH="$1"

# Get the absolute path of the file
if [ ! -f "$FILE_PATH" ] && [ ! -d "$FILE_PATH" ]; then
    echo "Error: File or directory '$FILE_PATH' does not exist"
    exit 1
fi

ABSOLUTE_FILE_PATH=$(realpath "$FILE_PATH")

# Get the workspace root from Cursor/VS Code environment variable
# Try multiple environment variables that VS Code/Cursor might set
WORKSPACE_ROOT="${VSCODE_WORKSPACE_FOLDER:-${WORKSPACE_FOLDER:-${PWD}}}"

# If the file is not in the workspace, use the file's directory as workspace
if [ ! -z "$WORKSPACE_ROOT" ] && [ -d "$WORKSPACE_ROOT" ]; then
    # Check if file is within workspace
    if [[ "$ABSOLUTE_FILE_PATH" != "$WORKSPACE_ROOT"/* ]] && [[ "$ABSOLUTE_FILE_PATH" != "$WORKSPACE_ROOT" ]]; then
        # File is outside workspace, use file's directory
        WORKSPACE_ROOT=$(dirname "$ABSOLUTE_FILE_PATH")
    fi
else
    # Fallback to file's directory
    WORKSPACE_ROOT=$(dirname "$ABSOLUTE_FILE_PATH")
fi

# Change to workspace root and open the file in neovim
cd "$WORKSPACE_ROOT" || exit 1

# Get relative path from workspace root
if [ "$WORKSPACE_ROOT" != "$(dirname "$ABSOLUTE_FILE_PATH")" ]; then
    RELATIVE_PATH=$(realpath --relative-to="$WORKSPACE_ROOT" "$ABSOLUTE_FILE_PATH")
else
    RELATIVE_PATH=$(basename "$ABSOLUTE_FILE_PATH")
fi

# Debug output (visible in task output)
echo "=== Opening file in Neovim ===" >&2
echo "File path: $FILE_PATH" >&2
echo "Absolute path: $ABSOLUTE_FILE_PATH" >&2
echo "Workspace root: $WORKSPACE_ROOT" >&2
echo "Relative path: $RELATIVE_PATH" >&2
echo "Current directory: $(pwd)" >&2

# Change to workspace root first
cd "$WORKSPACE_ROOT" || {
    echo "Error: Failed to change to workspace root: $WORKSPACE_ROOT" >&2
    exit 1
}

# Verify nvim is available
if ! command -v nvim >/dev/null 2>&1; then
    echo "Error: nvim command not found in PATH" >&2
    exit 1
fi

# Open neovim with the file in a new terminal window
# Use Ghostty if available (user's preferred terminal)
if command -v ghostty >/dev/null 2>&1; then
    echo "Launching Neovim in Ghostty terminal..." >&2
    
    # Ensure we have display environment (critical for GUI apps launched from tasks)
    if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
        # Try to get DISPLAY from parent processes or common locations
        export DISPLAY="${DISPLAY:-:0}"
        echo "Warning: No DISPLAY set, using ${DISPLAY}" >&2
    fi
    
    # Create a temporary script that ensures zsh stays open
    TEMP_SCRIPT=$(mktemp /tmp/nvim-open-zsh-XXXXXX.sh)
    cat > "$TEMP_SCRIPT" <<'ZSHSCRIPT'
#!/usr/bin/env zsh
cd "$1" || exit 1
nvim "$2"
# After nvim exits, start an interactive zsh session
# Use -l for login shell to ensure proper initialization
exec zsh -l
ZSHSCRIPT
    chmod +x "$TEMP_SCRIPT"
    
    # Launch Ghostty completely detached from this process
    # Use setsid to create a new session, and nohup to prevent SIGHUP
    # This ensures Ghostty survives after the task script ends
    nohup setsid ghostty -e "$TEMP_SCRIPT" "$WORKSPACE_ROOT" "$RELATIVE_PATH" >/dev/null 2>&1 &
    GHOSTTY_PID=$!
    
    # Disown the process so it's not a child of this shell
    disown $GHOSTTY_PID 2>/dev/null || true
    
    # Clean up temp script after Ghostty has read it
    (sleep 3 && rm -f "$TEMP_SCRIPT") &
    
    echo "Launched Ghostty with command (PID: $GHOSTTY_PID)" >&2
    
    # Give Ghostty time to start and create window
    # But don't wait too long - the task can finish, Ghostty is detached
    sleep 0.5
    
    # Check if process is running
    if ps -p $GHOSTTY_PID >/dev/null 2>&1; then
        echo "Ghostty process is running (detached)" >&2
        
        # Give a bit more time for window to appear
        sleep 0.5
        
        # Try to focus the Ghostty window if using i3/Regolith
        if command -v i3-msg >/dev/null 2>&1; then
            # Try to focus the window
            i3-msg "[class=\"Ghostty\"] focus" >/dev/null 2>&1 || true
            echo "Attempted to focus Ghostty window" >&2
        fi
        
        echo "Neovim launched successfully in Ghostty" >&2
        echo "Note: Ghostty is detached and will continue running after task ends" >&2
    else
        echo "Warning: Could not verify Ghostty process, but it may have started" >&2
        echo "Check if Ghostty window appeared" >&2
    fi
elif command -v gnome-terminal >/dev/null 2>&1; then
    echo "Launching Neovim in gnome-terminal..." >&2
    gnome-terminal -- bash -c "cd '$WORKSPACE_ROOT' && nvim '$RELATIVE_PATH'; exec bash" &
    echo "Neovim launched successfully" >&2
elif command -v xterm >/dev/null 2>&1; then
    echo "Launching Neovim in xterm..." >&2
    xterm -e bash -c "cd '$WORKSPACE_ROOT' && nvim '$RELATIVE_PATH'; exec bash" &
    echo "Neovim launched successfully" >&2
elif [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
    # Try to find any terminal emulator
    TERMINAL=$(command -v x-terminal-emulator 2>/dev/null || command -v xterm 2>/dev/null || echo "")
    if [ -n "$TERMINAL" ]; then
        echo "Launching Neovim in $TERMINAL..." >&2
        $TERMINAL -e bash -c "cd '$WORKSPACE_ROOT' && nvim '$RELATIVE_PATH'; exec bash" &
        echo "Neovim launched successfully" >&2
    else
        echo "Warning: No terminal emulator found. Opening Neovim directly (will block task)" >&2
        nvim "$RELATIVE_PATH"
    fi
else
    echo "Warning: No GUI environment detected. Opening Neovim directly (will block task)" >&2
    nvim "$RELATIVE_PATH"
fi
