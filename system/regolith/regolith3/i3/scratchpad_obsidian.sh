#!/usr/bin/env bash
#
# Scratchpad script for Obsidian
# Works like scratchpad.sh - uses i3-msg scratchpad show which toggles automatically

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)

# Function to check if Obsidian window exists (by class, not title)
function has_obsidian_instance() {
    res=$(i3-msg -t get_tree | jq '.. | select(.window_properties? | .class == "obsidian") | any')
    if [[ $res == true ]]; then
        return 0
    else
        return 1
    fi
}

# Function to find Obsidian AppImage
function find_obsidian_appimage() {
    # Common AppImage locations
    local locations=(
        "$HOME/Applications"
        "$HOME/.local/bin"
        "$HOME/Applications/AppImages"
        "/opt"
    )
    
    for location in "${locations[@]}"; do
        if [ -d "$location" ]; then
            local appimage=$(find "$location" -maxdepth 1 -name "Obsidian*.AppImage" -type f 2>/dev/null | head -n 1)
            if [ -n "$appimage" ] && [ -f "$appimage" ]; then
                echo "$appimage"
                return 0
            fi
        fi
    done
    return 1
}

# Function to launch Obsidian
function launch_obsidian() {
    local obsidian_cmd=""
    local is_appimage=false
    
    # Try different methods to find Obsidian
    if command -v obsidian &> /dev/null; then
        obsidian_cmd="obsidian"
    elif [ -f "/snap/bin/obsidian" ]; then
        obsidian_cmd="/snap/bin/obsidian"
    elif appimage_path=$(find_obsidian_appimage); then
        obsidian_cmd="$appimage_path"
        is_appimage=true
    elif [ -f "/usr/bin/obsidian" ]; then
        obsidian_cmd="/usr/bin/obsidian"
    else
        echo "ERROR: Obsidian not found. Please install Obsidian first" >&2
        exit 1
    fi

    # Launch Obsidian in background
    if [ "$is_appimage" = true ] && [ -f "${DIR}/obsidian-wrapper.sh" ]; then
        "${DIR}/obsidian-wrapper.sh" "${obsidian_cmd}" &
    else
        "${obsidian_cmd}" &
    fi

    # Wait for Obsidian window to appear
    local max_wait=75  # 15 seconds (75 * 0.2)
    local waited=0
    while ! has_obsidian_instance; do
        sleep 0.2
        waited=$((waited + 1))
        if [ $waited -ge $max_wait ]; then
            echo "ERROR: Obsidian timeout - window did not appear" >&2
            exit 1
        fi
    done

    # Wait a bit more for window to fully initialize
    sleep 0.5

    # Configure the window and move to scratchpad
    i3-msg [class="obsidian"] border normal 10 2>/dev/null
    i3-msg [class="obsidian"] move scratchpad 2>/dev/null
    i3-msg [class="obsidian"] scratchpad show 2>/dev/null
}

function toggle_obsidian_scratchpad() {
    # Try to toggle scratchpad - this shows if hidden, hides if visible
    # --quiet makes it return false if no matching window found
    if ! i3-msg [class="obsidian"] --quiet scratchpad show; then
        # scratchpad show failed - either window doesn't exist or is not in scratchpad
        
        if ! has_obsidian_instance; then
            # No Obsidian window exists, launch it
            launch_obsidian
        else
            # Obsidian exists but not in scratchpad (maybe tiled), move it to scratchpad
            i3-msg [class="obsidian"] border normal 10 2>/dev/null
            i3-msg [class="obsidian"] move scratchpad 2>/dev/null
            i3-msg [class="obsidian"] scratchpad show 2>/dev/null
        fi
    fi
}

toggle_obsidian_scratchpad
