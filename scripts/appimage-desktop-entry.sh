#!/bin/bash
set -e
set -o pipefail

# Directories
APPIMAGE_DIR="${HOME}/.local/appimage"
BIN_DIR="${HOME}/.local/bin"
ICON_FOLDER="${HOME}/.local/share/icons"
DESKTOP_ENTRY_DIR="${HOME}/.local/share/applications"

# Ensure directories exist
mkdir -p "${APPIMAGE_DIR}" "${BIN_DIR}" "${ICON_FOLDER}" "${DESKTOP_ENTRY_DIR}"

validate_appimage() {
    local appimage_path="$1"

    if [ -z "$appimage_path" ]; then
        echo "Usage: $(basename "$0") <appimage-file> [--remove]"
        echo ""
        echo "Install an AppImage by:"
        echo "  - Moving it to ~/.local/appimage/"
        echo "  - Creating a symlink in ~/.local/bin/"
        echo "  - Creating a desktop entry"
        echo ""
        echo "Options:"
        echo "  --remove    Remove the AppImage and its desktop entry"
        exit 1
    fi

    if [ ! -f "$appimage_path" ]; then
        echo "Error: File not found: $appimage_path"
        exit 1
    fi
}

ensure_executable() {
    local file="$1"

    if [ ! -x "$file" ]; then
        echo "Making AppImage executable..."
        chmod +x "$file"
    fi
}

remove_appimage() {
    local app_name="$1"
    local appimage_file="${APPIMAGE_DIR}/${app_name}.AppImage"
    local bin_link="${BIN_DIR}/${app_name}"
    local desktop_entry="${DESKTOP_ENTRY_DIR}/${app_name}.desktop"

    echo "Removing AppImage: $app_name"

    # Remove symlink
    if [ -L "$bin_link" ]; then
        rm -f "$bin_link"
        echo "  ✓ Removed symlink: $bin_link"
    fi

    # Remove desktop entry
    if [ -f "$desktop_entry" ]; then
        rm -f "$desktop_entry"
        echo "  ✓ Removed desktop entry"
    fi

    # Remove icon
    find "${ICON_FOLDER}" -maxdepth 1 -type f -name "$app_name.*" -delete
    echo "  ✓ Removed icon"

    # Remove AppImage
    if [ -f "$appimage_file" ]; then
        rm -f "$appimage_file"
        echo "  ✓ Removed AppImage: $appimage_file"
    fi

    echo "Removed successfully"
}

extract_and_choose_icon() {
    local appimage_path="$1"
    local temp_dir="$2"
    local -n icon_result="$3"  # nameref for output

    pushd "$temp_dir" > /dev/null
    "$appimage_path" --appimage-extract > /dev/null
    cd squashfs-root/

    echo "Choose icon: "
    # Find icon files (both regular files and symlinks)
    mapfile -t FILENAMES < <(find . -maxdepth 1 \( -type f -o -type l \) \( -iname '*.png' -o -iname '*.svg' -o -iname '.DirIcon' \))

    if [ ${#FILENAMES[@]} -eq 0 ]; then
        echo "Warning: No icons found in AppImage"
        popd > /dev/null
        return 1
    fi

    local i=1
    for filename in "${FILENAMES[@]}"; do
        printf " %d) %s\n" "$i" "$filename"
        i=$((i + 1))
    done

    read -r SELECTED_INDEX

    # Validate input
    if [ -z "$SELECTED_INDEX" ]; then
        echo "Error: No selection made"
        popd > /dev/null
        return 1
    fi

    if ! [[ "$SELECTED_INDEX" =~ ^[0-9]+$ ]] || [ "$SELECTED_INDEX" -lt 1 ] || [ "$SELECTED_INDEX" -gt "${#FILENAMES[@]}" ]; then
        echo "Error: Invalid selection. Please enter a number between 1 and ${#FILENAMES[@]}"
        popd > /dev/null
        return 1
    fi

    local ICON_SRC=${FILENAMES[$((SELECTED_INDEX - 1))]}
    
    # Follow symlinks if necessary
    if [ -L "$ICON_SRC" ]; then
        ICON_SRC=$(readlink -f "$ICON_SRC")
    else
        ICON_SRC="$temp_dir/squashfs-root/$ICON_SRC"
    fi
    
    if [ -z "$ICON_SRC" ] || [ ! -f "$ICON_SRC" ]; then
        echo "Error: Selected icon file not found: $ICON_SRC"
        popd > /dev/null
        return 1
    fi
    
    popd > /dev/null

    icon_result="$ICON_SRC"
    return 0
}

detect_electron_app() {
    local temp_dir="$1"
    # Check if it's an Electron app by looking for common Electron files
    if [ -f "$temp_dir/squashfs-root/chrome-sandbox" ] || \
       [ -f "$temp_dir/squashfs-root/libffmpeg.so" ] || \
       grep -q "electron" "$temp_dir/squashfs-root/"*.json 2>/dev/null; then
        return 0  # Is Electron
    fi
    return 1  # Not Electron
}

install_appimage() {
    local appimage_path="$1"
    local temp_dir=$(mktemp -d)

    # Ensure the AppImage is executable
    ensure_executable "$appimage_path"

    # Get full path and filename
    local appimage_fullpath=$(readlink -e "$appimage_path")
    local appimage_filename=$(basename "$appimage_path")
    local app_name="${appimage_filename%.*}"

    # Destination paths
    local appimage_dest="${APPIMAGE_DIR}/${app_name}.AppImage"
    local bin_link="${BIN_DIR}/${app_name}"
    local desktop_entry="${DESKTOP_ENTRY_DIR}/${app_name}.desktop"

    # Extract and select icon
    local icon_src=""
    extract_and_choose_icon "$appimage_fullpath" "$temp_dir" icon_src

    if [ -z "$icon_src" ] || [ ! -f "$icon_src" ]; then
        echo "Error: Failed to select icon"
        rm -rf "$temp_dir"
        exit 1
    fi

    local icon_ext="${icon_src##*.}"
    local icon_dst="${ICON_FOLDER}/${app_name}.${icon_ext}"

    # Copy icon
    cp "$icon_src" "$icon_dst"
    echo "✓ Icon copied to: $icon_dst"

    # Detect if it's an Electron app
    local electron_flags=""
    if detect_electron_app "$temp_dir"; then
        electron_flags=" --no-sandbox"
        echo "✓ Detected Electron app - will use --no-sandbox flag"
    fi

    # Move AppImage to dedicated directory
    if [ "$appimage_fullpath" != "$appimage_dest" ]; then
        cp "$appimage_fullpath" "$appimage_dest"
        chmod +x "$appimage_dest"
        echo "✓ AppImage installed to: $appimage_dest"
    else
        echo "✓ AppImage already in correct location"
    fi

    # Create wrapper script in ~/.local/bin (instead of symlink)
    if [ -L "$bin_link" ] || [ -f "$bin_link" ]; then
        rm -f "$bin_link"
    fi
    cat > "$bin_link" <<EOF
#!/bin/bash
exec "$appimage_dest"${electron_flags} "\$@"
EOF
    chmod +x "$bin_link"
    echo "✓ Wrapper script created: $bin_link"

    # Create desktop entry
    cat <<EOT > "$desktop_entry"
[Desktop Entry]
Name=$app_name
StartupWMClass=$app_name
Exec=$appimage_dest${electron_flags}
Icon=$icon_dst
Type=Application
Terminal=false
EOT

    echo "✓ Desktop entry created: $desktop_entry"

    # Cleanup
    rm -rf "$temp_dir"

    echo ""
    echo "Installation complete!"
    echo "You can now run '$app_name' from the command line"
}

main() {
    local appimage_path="$1"
    local action="$2"

    validate_appimage "$appimage_path"

    local appimage_filename=$(basename "$appimage_path")
    local app_name="${appimage_filename%.*}"

    if [ "$action" == "--remove" ]; then
        remove_appimage "$app_name"
    else
        install_appimage "$appimage_path"
    fi
}

main "$@"
