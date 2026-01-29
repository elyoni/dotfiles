#!/usr/bin/env bash
# Remote installation script for vim log syntax highlighting
# Usage: ./install_remote.sh [user@]hostname [ssh_options]

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "$DIR" && pwd)

function _usage() {
    cat << EOF
Usage: $0 [OPTIONS] [user@]hostname

Options:
    -p, --port PORT        SSH port (default: 22)
    -i, --identity FILE    SSH identity file
    -h, --help             Show this help message

Examples:
    $0 user@example.com                    # Install
    $0 verify user@example.com             # Verify installation
    $0 diagnose user@example.com           # Run diagnostic
    $0 -p 2222 user@example.com            # Install with custom port
    $0 -i ~/.ssh/id_rsa user@example.com  # Install with SSH key

This script will:
  1. Copy vim log syntax files to remote host
  2. Copy tail-log.sh script to remote host
  3. Install files directly to ~/.vim/ on remote host
  4. Verify installation

Note: Files are copied directly (not symlinked) on remote host.
EOF
}

function _install_remote() {
    local host="$1"
    local ssh_opts=("${@:2}")
    local remote_user
    local remote_host
    
    if [[ -z "$host" ]]; then
        echo "Error: Hostname required" >&2
        _usage
        return 1
    fi
    
    # Parse user@host
    if [[ "$host" == *"@"* ]]; then
        remote_user="${host%%@*}"
        remote_host="${host##*@}"
    else
        remote_user=""
        remote_host="$host"
    fi
    
    echo "=== Installing Vim Log Syntax on $host ==="
    echo ""
    
    # Check if rsync is available
    if ! command -v rsync >/dev/null 2>&1; then
        echo "Error: rsync is required but not found" >&2
        return 1
    fi
    
    # Check if ssh is available
    if ! command -v ssh >/dev/null 2>&1; then
        echo "Error: ssh is required but not found" >&2
        return 1
    fi
    
    # Setup SSH connection multiplexing to reuse connection
    local control_path="${HOME}/.ssh/control-%r@%h:%p"
    local control_dir="${HOME}/.ssh"
    mkdir -p "$control_dir"
    
    # Add ControlMaster options to reuse SSH connection
    local ssh_mux_opts=(
        -o "ControlMaster=auto"
        -o "ControlPath=$control_path"
        -o "ControlPersist=60"
    )
    
    # Combine all SSH options
    local all_ssh_opts=("${ssh_mux_opts[@]}" "${ssh_opts[@]}")
    
    # Test SSH connection (this will prompt for password once)
    echo "Testing SSH connection to $host..."
    echo "You may be prompted for your password once..."
    if ! ssh "${all_ssh_opts[@]}" "$host" "echo 'Connection successful'" 2>&1; then
        echo "Error: Cannot connect to $host via SSH" >&2
        echo "Please ensure SSH access is configured" >&2
        return 1
    fi
    echo "SSH connection successful (connection will be reused)"
    echo ""
    
    # Create temporary directory on remote (reuses connection)
    local remote_tmp
    remote_tmp=$(ssh "${all_ssh_opts[@]}" "$host" "mktemp -d" 2>/dev/null)
    if [[ -z "$remote_tmp" ]]; then
        echo "Error: Failed to create temporary directory on remote" >&2
        return 1
    fi
    echo "Created temporary directory on remote: $remote_tmp"
    
    # Copy files to remote using rsync (reuses SSH connection)
    echo "Copying files to remote host..."
    # Build SSH command for rsync with connection reuse
    local rsync_ssh_opts=()
    if [[ ${#all_ssh_opts[@]} -gt 0 ]]; then
        local ssh_cmd_parts=("ssh")
        for opt in "${all_ssh_opts[@]}"; do
            ssh_cmd_parts+=("$opt")
        done
        local ssh_cmd
        printf -v ssh_cmd '%s ' "${ssh_cmd_parts[@]}"
        rsync_ssh_opts=(-e "${ssh_cmd% }")
    fi
    
    # Copy files preserving directory structure
    # Note: rsync with trailing slash copies contents, without slash copies the directory
    echo "Copying syntax directory..."
    if ! rsync -avz "${rsync_ssh_opts[@]}" \
        "${DIR}/syntax/" \
        "$host:$remote_tmp/syntax/" 2>&1; then
        echo "Error: Failed to copy syntax directory" >&2
        ssh "${all_ssh_opts[@]}" "$host" "rm -rf $remote_tmp" 2>/dev/null
        return 1
    fi
    
    echo "Copying ftdetect directory..."
    if ! rsync -avz "${rsync_ssh_opts[@]}" \
        "${DIR}/ftdetect/" \
        "$host:$remote_tmp/ftdetect/" 2>&1; then
        echo "Error: Failed to copy ftdetect directory" >&2
        ssh "${all_ssh_opts[@]}" "$host" "rm -rf $remote_tmp" 2>/dev/null
        return 1
    fi
    
    echo "Copying scripts..."
    if ! rsync -avz "${rsync_ssh_opts[@]}" \
        "${DIR}/tail-log.sh" \
        "${DIR}/install" \
        "${DIR}/remote_diagnose.sh" \
        "$host:$remote_tmp/" 2>&1; then
        echo "Error: Failed to copy scripts" >&2
        ssh "${all_ssh_opts[@]}" "$host" "rm -rf $remote_tmp" 2>/dev/null
        return 1
    fi
    
    echo "Files copied successfully"
    echo ""
    
    # Run all remote commands in a single SSH session (reuses connection)
    echo "Running installation on remote host..."
    ssh "${all_ssh_opts[@]}" "$host" << EOF
        set -e
        
        # Create directories
        mkdir -p "\${HOME}/.vim/syntax"
        mkdir -p "\${HOME}/.vim/ftdetect"
        mkdir -p "\${HOME}/.local/bin"
        
        # Remove any existing files or broken symlinks
        echo "Cleaning up existing files..."
        rm -f "\${HOME}/.vim/syntax/log.vim"
        rm -f "\${HOME}/.vim/ftdetect/log.vim"
        rm -f "\${HOME}/.local/bin/tailog"
        
        # Copy files directly (not symlinks, since temp dir will be deleted)
        echo "Installing syntax files..."
        if [[ -f "$remote_tmp/syntax/log.vim" ]]; then
            cp "$remote_tmp/syntax/log.vim" "\${HOME}/.vim/syntax/log.vim"
            echo "  ✓ Copied syntax file"
        else
            echo "  ✗ Syntax file not found at $remote_tmp/syntax/log.vim"
            ls -la "$remote_tmp/" || true
            ls -la "$remote_tmp/syntax/" 2>/dev/null || true
            exit 1
        fi
        
        if [[ -f "$remote_tmp/ftdetect/log.vim" ]]; then
            cp "$remote_tmp/ftdetect/log.vim" "\${HOME}/.vim/ftdetect/log.vim"
            echo "  ✓ Copied filetype detection"
        else
            echo "  ✗ Filetype detection not found at $remote_tmp/ftdetect/log.vim"
            ls -la "$remote_tmp/" || true
            ls -la "$remote_tmp/ftdetect/" 2>/dev/null || true
            exit 1
        fi
        
        # Install tail-log.sh if it exists
        if [[ -f "$remote_tmp/tail-log.sh" ]]; then
            cp "$remote_tmp/tail-log.sh" "\${HOME}/.local/bin/tailog"
            chmod +x "\${HOME}/.local/bin/tailog"
        fi
        
        # Verify installation
        echo ""
        echo "Verifying installation..."
        if [[ -f "\${HOME}/.vim/syntax/log.vim" ]]; then
            echo "✓ Syntax file installed"
        else
            echo "✗ Syntax file installation failed"
            exit 1
        fi
        
        if [[ -f "\${HOME}/.vim/ftdetect/log.vim" ]]; then
            echo "✓ Filetype detection installed"
        else
            echo "✗ Filetype detection installation failed"
            exit 1
        fi
        
        # Cleanup temporary directory
        rm -rf "$remote_tmp"
        
        echo ""
        echo "Installation complete"
        echo ""
        echo "To diagnose issues on the remote server, run:"
        echo "  bash $remote_tmp/remote_diagnose.sh"
        echo ""
        echo "Or copy remote_diagnose.sh to the server and run it there."
EOF
    
    local install_status=$?
    
    # Close SSH connection
    ssh -O exit "${all_ssh_opts[@]}" "$host" 2>/dev/null || true
    
    if [[ $install_status -eq 0 ]]; then
        echo ""
        echo "=== Installation completed successfully ==="
        echo ""
        echo "On the remote host, you can now use:"
        echo "  vim /path/to/logfile.log"
        echo "  tailog /path/to/logfile.log"
        echo ""
        echo "If syntax highlighting doesn't work, run diagnostic on remote:"
        echo "  ssh $host 'bash -s' < ${DIR}/remote_diagnose.sh"
        echo ""
        return 0
    else
        echo ""
        echo "Error: Installation failed on remote host" >&2
        return 1
    fi
}

function _diagnose_remote() {
    local host="$1"
    local ssh_opts=("${@:2}")
    
    if [[ -z "$host" ]]; then
        echo "Error: Hostname required" >&2
        return 1
    fi
    
    # Setup SSH connection multiplexing
    local control_path="${HOME}/.ssh/control-%r@%h:%p"
    local ssh_mux_opts=(
        -o "ControlMaster=auto"
        -o "ControlPath=$control_path"
        -o "ControlPersist=60"
    )
    local all_ssh_opts=("${ssh_mux_opts[@]}" "${ssh_opts[@]}")
    
    echo "=== Running diagnostic on $host ==="
    echo ""
    
    # Run diagnostic script remotely
    ssh "${all_ssh_opts[@]}" "$host" 'bash -s' < "${DIR}/remote_diagnose.sh"
    
    local diag_status=$?
    
    # Close SSH connection
    ssh -O exit "${all_ssh_opts[@]}" "$host" 2>/dev/null || true
    
    return $diag_status
}

function _verify_remote() {
    local host="$1"
    local ssh_opts=("${@:2}")
    
    if [[ -z "$host" ]]; then
        echo "Error: Hostname required" >&2
        return 1
    fi
    
    # Setup SSH connection multiplexing
    local control_path="${HOME}/.ssh/control-%r@%h:%p"
    local ssh_mux_opts=(
        -o "ControlMaster=auto"
        -o "ControlPath=$control_path"
        -o "ControlPersist=60"
    )
    local all_ssh_opts=("${ssh_mux_opts[@]}" "${ssh_opts[@]}")
    
    echo "=== Verifying installation on $host ==="
    echo ""
    
    ssh "${all_ssh_opts[@]}" "$host" << 'EOF'
        # Check vim
        if ! command -v vim >/dev/null 2>&1; then
            echo "✗ vim is not installed"
            exit 1
        else
            echo "✓ vim is installed"
            vim --version | head -n 1
        fi
        
        # Check syntax file
        if [[ -f ~/.vim/syntax/log.vim ]]; then
            echo "✓ Syntax file exists ($(stat -f%z ~/.vim/syntax/log.vim 2>/dev/null || stat -c%s ~/.vim/syntax/log.vim 2>/dev/null) bytes)"
        elif [[ -L ~/.vim/syntax/log.vim ]]; then
            echo "⚠ Syntax file is a symlink (should be a regular file on remote)"
            if [[ -e ~/.vim/syntax/log.vim ]]; then
                echo "  But symlink is valid"
            else
                echo "  ✗ Symlink is broken"
                exit 1
            fi
        else
            echo "✗ Syntax file not found"
            exit 1
        fi
        
        # Check filetype detection
        if [[ -f ~/.vim/ftdetect/log.vim ]]; then
            echo "✓ Filetype detection exists"
        elif [[ -L ~/.vim/ftdetect/log.vim ]]; then
            echo "⚠ Filetype detection is a symlink (should be a regular file on remote)"
            if [[ -e ~/.vim/ftdetect/log.vim ]]; then
                echo "  But symlink is valid"
            else
                echo "  ✗ Symlink is broken"
                exit 1
            fi
        else
            echo "✗ Filetype detection not found"
            exit 1
        fi
        
        # Check tailog script
        if command -v tailog >/dev/null 2>&1; then
            echo "✓ tailog script is available in PATH"
        elif [[ -f ~/.local/bin/tailog ]] || [[ -L ~/.local/bin/tailog ]]; then
            echo "✓ tailog script exists at ~/.local/bin/tailog"
            echo "  (Make sure ~/.local/bin is in your PATH)"
        else
            echo "⚠ tailog script not found (optional)"
        fi
        
        echo ""
        echo "Verification complete"
EOF
    
    # Close SSH connection
    ssh -O exit "${all_ssh_opts[@]}" "$host" 2>/dev/null || true
}

# Main script
main() {
    local ssh_opts=()
    local host=""
    local command="install"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--port)
            ssh_opts+=(-p "$2")
            shift 2
            ;;
        -i|--identity)
            ssh_opts+=(-i "$2")
            shift 2
            ;;
        -h|--help)
            _usage
            exit 0
            ;;
        verify)
            command="verify"
            shift
            ;;
        diagnose)
            command="diagnose"
            shift
            ;;
        install)
            command="install"
            shift
            ;;
        -*)
            echo "Unknown option: $1" >&2
            _usage
            return 1
            ;;
        *)
            if [[ -z "$host" ]]; then
                host="$1"
            else
                echo "Error: Multiple hosts specified" >&2
                _usage
                return 1
            fi
            shift
            ;;
    esac
    done
    
    # Main logic
    if [[ -z "$host" ]]; then
        echo "Error: Hostname required" >&2
        _usage
        return 1
    fi
    
    case "$command" in
        install)
            _install_remote "$host" "${ssh_opts[@]}"
            ;;
        verify)
            _verify_remote "$host" "${ssh_opts[@]}"
            ;;
        diagnose)
            _diagnose_remote "$host" "${ssh_opts[@]}"
            ;;
        *)
            echo "Unknown command: $command" >&2
            _usage
            return 1
            ;;
    esac
}

# Run main function
main "$@"











