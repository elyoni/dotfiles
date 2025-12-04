#!/usr/bin/env bash
#
# Scratchpad script for Obsidian
# Since Obsidian is a GUI app, we don't need tmux wrapper

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)

scratchpad_title="obsidian-scratchpad"

# Check if Obsidian is already running with our title
if ! i3-msg [title="${scratchpad_title}"] --quiet scratchpad show; then
    # Launch Obsidian
    # Note: Obsidian is typically installed as an AppImage, snap, or deb package
    if command -v obsidian &> /dev/null; then
        obsidian &
    elif [ -f "/snap/bin/obsidian" ]; then
        /snap/bin/obsidian &
    elif [ -f "$HOME/Applications/Obsidian.AppImage" ]; then
        "$HOME/Applications/Obsidian.AppImage" &
    elif [ -f "/usr/bin/obsidian" ]; then
        /usr/bin/obsidian &
    else
        notify-send "Obsidian not found" "Please install Obsidian first"
        exit 1
    fi
    
    # Wait for Obsidian window to appear
    sleep 2
    
    # Find the Obsidian window and configure it
    i3-msg [class="obsidian"] title_format "<b>${scratchpad_title}</b>"
    i3-msg [class="obsidian"] border normal 10
    i3-msg [class="obsidian"] move scratchpad
    i3-msg [class="obsidian"] scratchpad show
fi


