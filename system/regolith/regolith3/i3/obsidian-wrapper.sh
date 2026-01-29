#!/usr/bin/env bash
#
# Wrapper script for Obsidian AppImage to handle sandbox permissions
# Configure this script outside the main scratchpad script
#
# Options:
# 1. Use --no-sandbox flag (default - simplest solution)
# 2. Fix sandbox permissions using sudo (configure sudo permissions separately)

OBSIDIAN_APPIMAGE="$1"

if [ -z "$OBSIDIAN_APPIMAGE" ] || [ ! -f "$OBSIDIAN_APPIMAGE" ]; then
    echo "ERROR: Obsidian AppImage path required" >&2
    exit 1
fi

# Option 1: Use --no-sandbox flag (default - simplest solution)
exec "$OBSIDIAN_APPIMAGE" --no-sandbox "$@"

# Option 2: Fix sandbox permissions (requires sudo configuration)
# Uncomment below and comment Option 1 above to use this method
#
# Launch AppImage in background
# "$OBSIDIAN_APPIMAGE" &
# APPIMAGE_PID=$!
#
# Wait for AppImage to mount (check for mount directory)
# max_wait=5
# waited=0
# mount_dir=""
#
# while [ $waited -lt $max_wait ]; do
#     mount_dir=$(find /tmp -maxdepth 1 -type d -name ".mount_Obsidi*" 2>/dev/null | head -n 1)
#     if [ -n "$mount_dir" ] && [ -d "$mount_dir" ]; then
#         break
#     fi
#     sleep 0.2
#     waited=$((waited + 1))
# done
#
# Fix sandbox permissions if mount directory found
# Configure sudo permissions separately using: sudo visudo
# Add line: your_username ALL=(ALL) NOPASSWD: /path/to/obsidian-wrapper.sh
# if [ -n "$mount_dir" ] && [ -f "${mount_dir}/chrome-sandbox" ]; then
#     sudo chown root:root "${mount_dir}/chrome-sandbox" 2>/dev/null && \
#     sudo chmod 4755 "${mount_dir}/chrome-sandbox" 2>/dev/null || {
#         echo "WARNING: Could not fix sandbox permissions" >&2
#     }
# fi
#
# Wait for the process (AppImage will continue launching)
# wait $APPIMAGE_PID 2>/dev/null || true
