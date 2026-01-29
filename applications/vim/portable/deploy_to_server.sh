#!/usr/bin/env bash
# Deploy portable vim package to remote server
# Usage: ./deploy_to_server.sh [package.tar.gz] [user@]hostname

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "$DIR" && pwd)

function _usage() {
    cat << EOF
Usage: $0 [OPTIONS] [package.tar.gz] [user@]hostname

Options:
    -p, --port PORT        SSH port (default: 22)
    -i, --identity FILE    SSH identity file
    -h, --help             Show this help message

Examples:
    $0 portable_vim_*.tar.gz user@example.com
    $0 -p 2222 portable_vim_*.tar.gz user@example.com

If package is not specified, will look for latest in current directory.
EOF
}

function _deploy() {
    local package="$1"
    local host="$2"
    local ssh_opts=("${@:3}")
    
    if [[ -z "$package" ]] || [[ -z "$host" ]]; then
        echo "Error: Package and hostname required" >&2
        _usage
        return 1
    fi
    
    # Find package if glob pattern
    if [[ "$package" == *"*"* ]]; then
        package=$(ls -t $package 2>/dev/null | head -1)
        if [[ -z "$package" ]]; then
            echo "Error: No package found matching pattern" >&2
            return 1
        fi
        echo "Using package: $package"
    fi
    
    if [[ ! -f "$package" ]]; then
        echo "Error: Package file not found: $package" >&2
        return 1
    fi
    
    echo "=== Deploying Portable Vim to $host ==="
    echo ""
    
    # Setup SSH connection multiplexing
    local control_path="${HOME}/.ssh/control-%r@%h:%p"
    local ssh_mux_opts=(
        -o "ControlMaster=auto"
        -o "ControlPath=$control_path"
        -o "ControlPersist=60"
    )
    local all_ssh_opts=("${ssh_mux_opts[@]}" "${ssh_opts[@]}")
    
    # Test SSH connection
    echo "Testing SSH connection..."
    if ! ssh "${all_ssh_opts[@]}" "$host" "echo 'Connection successful'" >/dev/null 2>&1; then
        echo "Error: Cannot connect to $host via SSH" >&2
        return 1
    fi
    echo "✓ SSH connection successful"
    echo ""
    
    # Create remote temp directory
    local remote_tmp
    remote_tmp=$(ssh "${all_ssh_opts[@]}" "$host" "mktemp -d")
    echo "Created temporary directory: $remote_tmp"
    
    # Copy package
    echo "Copying package to remote server..."
    if ! scp "${all_ssh_opts[@]}" "$package" "$host:$remote_tmp/" 2>&1; then
        echo "Error: Failed to copy package" >&2
        ssh "${all_ssh_opts[@]}" "$host" "rm -rf $remote_tmp" 2>/dev/null
        return 1
    fi
    echo "✓ Package copied"
    echo ""
    
    # Extract and install on remote
    echo "Installing on remote server..."
    ssh "${all_ssh_opts[@]}" "$host" << EOF
        set -e
        cd "$remote_tmp"
        tar xzf "$(basename "$package")"
        cd portable_vim
        ./install.sh
        echo ""
        echo "=== Installation Complete ==="
        echo ""
        echo "Vim is now available. Test with:"
        echo "  ~/.local/bin/vim --version"
        echo "  ~/.local/bin/vim /path/to/logfile.log"
EOF
    
    local install_status=$?
    
    # Cleanup
    ssh "${all_ssh_opts[@]}" "$host" "rm -rf $remote_tmp" 2>/dev/null
    
    # Close SSH connection
    ssh -O exit "${all_ssh_opts[@]}" "$host" 2>/dev/null || true
    
    if [[ $install_status -eq 0 ]]; then
        echo ""
        echo "=== Deployment Successful ==="
        echo ""
        echo "On the remote server, vim is now available at:"
        echo "  ~/.local/bin/vim"
        echo ""
        echo "Make sure ~/.local/bin is in your PATH, or use:"
        echo "  export PATH=\$HOME/.local/bin:\$PATH"
        return 0
    else
        echo ""
        echo "Error: Installation failed on remote host" >&2
        return 1
    fi
}

# Main
ssh_opts=()
package=""
host=""

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
        -*)
            echo "Unknown option: $1" >&2
            _usage
            exit 1
            ;;
        *)
            if [[ -z "$package" ]]; then
                package="$1"
            elif [[ -z "$host" ]]; then
                host="$1"
            else
                echo "Error: Too many arguments" >&2
                _usage
                exit 1
            fi
            shift
            ;;
    esac
done

# If no package specified, find latest
if [[ -z "$package" ]]; then
    package=$(ls -t "${DIR}"/portable_vim_*.tar.gz 2>/dev/null | head -1)
    if [[ -z "$package" ]]; then
        echo "Error: No package found. Build one first with:" >&2
        echo "  cd ${DIR} && ./build_portable.sh" >&2
        exit 1
    fi
    echo "Using latest package: $package"
fi

if [[ -z "$host" ]]; then
    echo "Error: Hostname required" >&2
    _usage
    exit 1
fi

_deploy "$package" "$host" "${ssh_opts[@]}"











