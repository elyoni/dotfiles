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

# Build a new args array with StrictHostKeyChecking=accept-new injected after "ssh"
function _args_with_accept_new_key() {
    local ssh_command="$1"
    shift
    local args=("$@")
    local new_args=()
    local i=1

    if [[ "$ssh_command" == "sshpass" ]]; then
        while [[ $i -le ${#args[@]} ]]; do
            new_args+=("${args[$i]}")
            if [[ "${args[$i]}" == "ssh" ]]; then
                new_args+=("-o" "StrictHostKeyChecking=accept-new")
                ((i++))
                break
            fi
            ((i++))
        done
        while [[ $i -le ${#args[@]} ]]; do
            new_args+=("${args[$i]}")
            ((i++))
        done
    else
        new_args=("-o" "StrictHostKeyChecking=accept-new" "${args[@]}")
    fi

    echo "${new_args[@]}"
}

# Helper function to handle SSH host key conflicts and other issues
function _handle_ssh_smart() {
    local ssh_command="$1"
    shift
    local args=("$@")

    local exit_code
    local host_ip
    local ssh_stderr=""
    local tmpfile
    tmpfile=$(mktemp)

    # Run with stdin/stdout connected to the terminal (interactive session works)
    # and stderr captured to a temp file so we can detect specific errors after.
    # sshpass uses a pty so SSH's stderr goes through the pty to the terminal;
    # for sshpass we rely on exit codes, not stderr content.
    command $ssh_command "${args[@]}" 2>|"$tmpfile"
    exit_code=$?
    ssh_stderr=$(cat "$tmpfile")
    rm -f "$tmpfile"

    [[ $exit_code -eq 0 ]] && return 0

    # sshpass exit code 6 = host key unknown or changed
    local is_host_key_failure=false
    if [[ "$ssh_command" == "sshpass" && $exit_code -eq 6 ]]; then
        is_host_key_failure=true
    elif echo "$ssh_stderr" | grep -q "Host key verification failed"; then
        is_host_key_failure=true
    fi

    if [[ "$is_host_key_failure" == true ]]; then
        [[ -n "$ssh_stderr" ]] && echo "$ssh_stderr" && echo ""

        if [[ "$ssh_command" == "sshpass" ]]; then
            host_ip=$(_extract_ssh_host "sshpass" "${args[@]}")
        else
            host_ip=$(_extract_ssh_host "${args[@]}")
        fi

        echo "Host key conflict detected for: $host_ip"
        echo ""
        read -q "REPLY?Remove old host key and reconnect? (y/N): "
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Removing old host key for $host_ip..."
            ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "$host_ip" 2>/dev/null || true
            ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[$host_ip]" 2>/dev/null || true
            # also remove by the resolved IP/hostname (alias → real address via ssh -G)
            local resolved_host
            resolved_host=$(ssh -G "$host_ip" 2>/dev/null | awk '/^hostname / {print $2; exit}')
            if [[ -n "$resolved_host" && "$resolved_host" != "$host_ip" ]]; then
                echo "Removing old host key for resolved address $resolved_host..."
                ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "$resolved_host" 2>/dev/null || true
                ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[$resolved_host]" 2>/dev/null || true
            fi
            echo "Host key removed. Reconnecting..."
            echo ""

            local new_args
            new_args=($(_args_with_accept_new_key "$ssh_command" "${args[@]}"))
            command $ssh_command "${new_args[@]}"
            return $?
        else
            echo "Connection aborted"
            return 1
        fi
    elif echo "$ssh_stderr" | grep -q -E "(Permission denied|Authentication failed)"; then
        [[ -n "$ssh_stderr" ]] && echo "$ssh_stderr"
        echo ""
        echo "Authentication failed - please check your credentials"
        return $exit_code
    elif echo "$ssh_stderr" | grep -q -E "(No route to host|Connection refused|Connection timed out|Network is unreachable)"; then
        [[ -n "$ssh_stderr" ]] && echo "$ssh_stderr"
        echo ""
        echo "Network issue detected. Retrying every 5 seconds. Press Ctrl+C to cancel."
        echo ""

        if [[ "$ssh_command" == "sshpass" ]]; then
            host_ip=$(_extract_ssh_host "sshpass" "${args[@]}")
        else
            host_ip=$(_extract_ssh_host "${args[@]}")
        fi

        local retry_count=1
        while true; do
            echo "Retry #$retry_count - connecting to $host_ip..."
            command $ssh_command "${args[@]}" 2>/dev/null
            [[ $? -eq 0 ]] && return 0
            echo "Failed, waiting 5 seconds..."
            sleep 5
            ((retry_count++))
        done
    else
        [[ -n "$ssh_stderr" ]] && echo "$ssh_stderr"
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

# --- git co: worktree-aware checkout (branch switch / cd to worktree / -b / -w -b / -) ---

function _git_co_repo_root() {
    local git_common_dir
    git_common_dir=$(command git rev-parse --git-common-dir 2>/dev/null) || return 1
    if [[ "$git_common_dir" == ".git" ]]; then
        command git rev-parse --show-toplevel 2>/dev/null
    else
        [[ -n "$git_common_dir" ]] && echo "${git_common_dir:h}"
    fi
}

function _git_co_common_dir() {
    command git rev-parse --git-common-dir 2>/dev/null
}

function _git_co_save_last() {
    local path="$1"
    local common_dir
    common_dir=$(_git_co_common_dir) || return
    [[ -z "$path" || -z "$common_dir" ]] && return
    print -r -- "$path" > "${common_dir}/last-co" 2>/dev/null
}

function _git_co_worktree_path() {
    local branch="$1"
    local repo_root="$2"
    command git -C "$repo_root" worktree list --porcelain 2>/dev/null | \
        awk -v branch="refs/heads/$branch" 'BEGIN {wt=""} /^worktree / {wt=$2} /^branch / {if ($2 == branch && wt != "") {print wt; exit}}'
}

function _git_co_impl() {
    local repo_root common_dir branch target_path start_point repo_name
    local has_b=false has_w=false

    # Not in a repo: pass through to git checkout
    repo_root=$(_git_co_repo_root) || {
        command git checkout "$@"
        return $?
    }
    common_dir=$(_git_co_common_dir)

    # git co -
    if [[ "$1" == "-" ]]; then
        if [[ -f "${common_dir}/last-co" ]]; then
            local last_path
            last_path=$(< "${common_dir}/last-co")
            if [[ -n "$last_path" && -d "$last_path" ]]; then
                cd "$last_path" || return 1
                return 0
            fi
        fi
        echo "git co -: no previous branch/worktree saved." >&2
        return 1
    fi

    # Parse -b and -w
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -b) has_b=true; shift ;;
            -w) has_w=true; shift ;;
            *) break ;;
        esac
    done

    # git co -w -b <branch>
    if [[ "$has_w" == true && "$has_b" == true ]]; then
        branch="$1"
        if [[ -z "$branch" ]]; then
            echo "Usage: git co -w -b <branch-name>" >&2
            return 1
        fi
        local current_dir=$(pwd)
        if [[ "$current_dir" == "$repo_root" ]]; then
            repo_name=${repo_root:t}
            target_path="${repo_root:h}/${repo_name}-${branch}"
        else
            target_path="$repo_root/.worktree/$branch"
            mkdir -p "$repo_root/.worktree" 2>/dev/null
        fi
        if [[ "$target_path" != /* ]]; then
            target_path=$(cd "${target_path:h}" && pwd)/${target_path:t}
        fi
        start_point=$(command git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")
        if command git -C "$repo_root" worktree add -b "$branch" "$target_path" "$start_point" 2>/dev/null; then
            _git_co_save_last "$target_path"
            cd "$target_path" || return 1
            return 0
        fi
        echo "git co -w -b: failed to create worktree." >&2
        return 1
    fi

    # git co -b <branch>
    if [[ "$has_b" == true ]]; then
        command git checkout -b "$@"
        local ret=$?
        (( ret == 0 )) && _git_co_save_last "$(pwd)"
        return $ret
    fi

    # git co <branch>
    branch="$1"
    if [[ -z "$branch" ]]; then
        command git checkout "$@"
        return $?
    fi

    target_path=$(_git_co_worktree_path "$branch" "$repo_root")
    if [[ -n "$target_path" && -d "$target_path" ]]; then
        _git_co_save_last "$target_path"
        cd "$target_path" || return 1
        return 0
    fi

    if command git -C "$repo_root" show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
        command git checkout "$branch" || return $?
        _git_co_save_last "$(pwd)"
        return 0
    fi

    command git checkout "$@"
}

# Open a Meld-like directory diff in neovim using diffview.nvim
# Usage: gdiff [ref]   (default: master)
function gdiff() {
    local ref="${1:-master}"
    nvim -c "DiffviewOpen ${ref}"
}
