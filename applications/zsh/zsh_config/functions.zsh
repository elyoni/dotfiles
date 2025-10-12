function srun() {
    sudo $(which "$1") "${@:2}"
}

# Load all zsh configuration files efficiently
function _load_zsh_configs() {
    local config_directory="$1"
    [[ -d "$config_directory" ]] || return

    for config_file in "$config_directory"/*.zsh; do
        [[ -f "$config_file" ]] && source "$config_file"
    done
}

# Helper function to extract host from SSH arguments
function _extract_ssh_host() {
    local args=("$@")
    local host_ip=""
    local i=1  # Start from 1 since 0 is function name or first arg
    local found_ssh=false

    # Check if this is a sshpass command
    if [[ "${args[1]}" == "sshpass" ]]; then
        # Skip sshpass and its options
        i=2
        while [[ $i -le ${#args[@]} ]]; do
            case "${args[$i]}" in
                -p|-f|-d|-P|-v|-e)
                    # These sshpass options take an argument, skip both
                    ((i += 2))
                    ;;
                ssh)
                    # Found ssh command, start processing SSH args
                    found_ssh=true
                    ((i++))
                    break
                    ;;
                -*)
                    # Other sshpass options without arguments
                    ((i++))
                    ;;
                *)
                    # This shouldn't happen in well-formed sshpass commands
                    ((i++))
                    ;;
            esac
        done
    else
        # Regular SSH command, start from beginning
        found_ssh=true
        i=1
    fi

    # Now extract host from SSH arguments
    if [[ $found_ssh == true ]]; then
        while [[ $i -le ${#args[@]} ]]; do
            # Skip SSH options that take arguments
            case "${args[$i]}" in
                -i|-p|-o|-F|-l|-c|-m|-S|-w|-W|-R|-L|-D)
                    # These SSH options take an argument, skip both
                    ((i += 2))
                    ;;
                -*)
                    # Other SSH options without arguments
                    ((i++))
                    ;;
                *)
                    # First non-option argument should be the host
                    host_ip="${args[$i]}"
                    break
                    ;;
            esac
        done
    fi

    # Extract just the hostname/IP if it contains user@host format
    if [[ "$host_ip" == *@* ]]; then
        host_ip="${host_ip##*@}"
    fi

    echo "$host_ip"
}

# Helper function to handle SSH host key conflicts and other issues
function _handle_ssh_smart() {
    local ssh_command="$1"
    shift
    local args=("$@")

    local ssh_output
    local exit_code
    local host_ip

    # Try SSH connection and capture output
    ssh_output=$(command $ssh_command "${args[@]}" 2>&1)
    exit_code=$?

    # Check if connection was successful
    if [[ $exit_code -eq 0 ]]; then
        return 0
    fi

    # Check for different types of failures
    if echo "$ssh_output" | grep -q "Host key verification failed"; then
        echo "$ssh_output"
        echo ""

        # Extract the host/IP from the command arguments
        if [[ "$ssh_command" == "sshpass" ]]; then
            host_ip=$(_extract_ssh_host "sshpass" "${args[@]}")
        else
            host_ip=$(_extract_ssh_host "${args[@]}")
        fi

        echo "🔑 Host key conflict detected for: $host_ip"
        echo ""
        read -q "REPLY?Do you want to remove the old host key and reconnect? (y/N): "
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🗑️  Removing old host key for $host_ip..."

            # Use ssh-keygen to remove the host key
            ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "$host_ip"
            ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[$host_ip]" 2>/dev/null

            echo "✅ Host key removed successfully"
            echo "🔄 Reconnecting..."
            echo ""

            # Reconnect with the original command
            command $ssh_command "${args[@]}"
            return $?
        else
            echo "❌ Connection aborted"
            return 1
        fi
    elif echo "$ssh_output" | grep -q -E "(Permission denied|Authentication failed)"; then
        echo "$ssh_output"
        echo ""
        echo "🔐 Authentication failed - please check your credentials"
        return $exit_code
    elif echo "$ssh_output" | grep -q -E "(No route to host|Connection refused|Connection timed out|Network is unreachable)"; then
        echo "$ssh_output"
        echo ""
        echo "🌐 Network connectivity issue detected"
        echo "⏱️  Will retry every 5 seconds. Press Ctrl+C to cancel."
        echo ""

        # Extract host for display
        if [[ "$ssh_command" == "sshpass" ]]; then
            host_ip=$(_extract_ssh_host "sshpass" "${args[@]}")
        else
            host_ip=$(_extract_ssh_host "${args[@]}")
        fi

        local retry_count=1
        while true; do
            echo "🔄 Retry #$retry_count - Attempting to connect to $host_ip..."

            # Try connection again
            if command $ssh_command "${args[@]}"; then
                return 0
            fi

            echo "❌ Connection failed, waiting 5 seconds..."
            sleep 5
            ((retry_count++))
        done
    else
        # For other SSH errors, just show the output
        echo "$ssh_output"
        return $exit_code
    fi
}

# Smart SSH function with different name
function sshs() {
    _handle_ssh_smart "ssh" "$@"
}

# Smart sshpass function with different name
function sshpasss() {
    _handle_ssh_smart "sshpass" "$@"
}

function my_precious() {
    sudo chown $(id -u):$(id -g) "$@"
}
