#!/bin/bash

# Script to add generic software sourcing to install scripts that need it
# This ensures all install scripts have access to essential tools

DOTFILES_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

add_generic_software_to_script() {
    local script_path="$1"
    local relative_path_to_utils="$2"

    # Check if script already sources generic software
    if grep -q "install_generic_software.sh" "$script_path"; then
        echo "Already updated: $script_path"
        return 0
    fi

    # Check if script uses curl, wget, or other tools that need generic software
    if ! grep -q -E "(curl|wget|git clone)" "$script_path"; then
        echo "Skipping: $script_path (doesn't seem to need generic tools)"
        return 0
    fi

    echo "Updating: $script_path"

    # Find the line after the DIR setup (usually line 3-4)
    local insert_line=$(grep -n "DIR.*pwd" "$script_path" | tail -1 | cut -d: -f1)
    if [ -z "$insert_line" ]; then
        insert_line=3  # Default to line 3
    fi
    insert_line=$((insert_line + 1))

    # Create a temporary file with the new content
    local temp_file=$(mktemp)

    # Write everything before the insertion point
    head -n $((insert_line - 1)) "$script_path" > "$temp_file"

    # Write the generic software sourcing block
    cat >> "$temp_file" << EOF

# Source generic software installation script
if [ -f "\${DIR}/${relative_path_to_utils}/install_generic_software.sh" ]; then
    source "\${DIR}/${relative_path_to_utils}/install_generic_software.sh"
    # Ensure generic software is installed before proceeding
    ensure_generic_software
fi
EOF

    # Write everything after the insertion point
    tail -n +$insert_line "$script_path" >> "$temp_file"

    # Replace the original file
    mv "$temp_file" "$script_path"
    chmod +x "$script_path"
}

# Find and update application install scripts
echo "Updating application install scripts..."
find "$DOTFILES_ROOT/applications" -name "install" -type f | while read -r script; do
    add_generic_software_to_script "$script" "../../utils"
done

# Find and update system install scripts
echo "Updating system install scripts..."
find "$DOTFILES_ROOT/system" -name "install" -type f | while read -r script; do
    add_generic_software_to_script "$script" "../../utils"
done

# Find and update programming language install scripts
echo "Updating programming language install scripts..."
find "$DOTFILES_ROOT/programming-languages" -name "install" -type f | while read -r script; do
    add_generic_software_to_script "$script" "../../utils"
done

echo "Generic software sourcing update completed!"
