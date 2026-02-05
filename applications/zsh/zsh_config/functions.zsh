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

# Smart git checkout with worktree support (use via "git co" only)
# Usage: git co [branch-name]
# Options:
#   --root, -r    Checkout in root folder instead of creating worktree
# If no branch provided, shows fzf menu with all branches (local, remote, worktrees)
# This function runs in the current shell, so cd works properly
# Execution function for git co
# Store a reference to this function before git_completion.zsh potentially overwrites it
# Load order: functions.zsh loads first, git_completion.zsh loads second
function _git_co_exec() {
    # This is the actual execution function - call the real implementation
    _git_co_impl "$@"
}

# The actual implementation
function _git_co_impl() {
    # #region agent log
    echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"B\",\"location\":\"functions.zsh:203\",\"message\":\"_git_co_impl() function entry\",\"data\":{\"args\":\"$@\"},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
    # #endregion
    local branch=""
    local checkout_in_root=0
    local create_branch=0
    local args=()

    # Parse arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            --root|-r)
                checkout_in_root=1
                shift
                ;;
            -b|--orphan)
                # These flags require the next argument to be the branch name
                create_branch=1
                args+=("$1")
                if [ $# -gt 1 ]; then
                    shift
                    branch="$1"
                    # Don't add branch to args, we'll handle it separately
                fi
                shift
                ;;
            --)
                shift
                args+=("$@")
                break
                ;;
            *)
                # Check if this looks like a git checkout flag (starts with -)
                if [[ "$1" =~ ^- ]]; then
                    # It's a flag, always add to args
                    args+=("$1")
                elif [ -z "$branch" ] && [ $create_branch -eq 0 ]; then
                    # First non-flag argument is the branch name (if not already set by -b)
                    branch="$1"
                else
                    # Additional arguments go to args
                    args+=("$1")
                fi
                shift
                ;;
        esac
    done

    # Get the main repository root, not the worktree root
    local git_common_dir
    git_common_dir=$(command git rev-parse --git-common-dir 2>/dev/null)
    local repo_root=""

    if [ -n "$git_common_dir" ]; then
        if [ "$git_common_dir" = ".git" ]; then
            repo_root=$(command git rev-parse --show-toplevel 2>/dev/null)
        else
            repo_root=$(dirname "$git_common_dir" 2>/dev/null)
        fi
    else
        repo_root=$(command git rev-parse --show-toplevel 2>/dev/null)
    fi

    if [ -z "$repo_root" ]; then
        # Not in a git repo - fall back to normal checkout
        if [ -n "$branch" ]; then
            command git checkout "$branch" "${args[@]}"
        else
            # If no branch and not in git repo, show error
            echo "Not in a git repository" >&2
            return 1
        fi
        return
    fi

    # Support "git co -" to switch back to previous branch
    if [ "$branch" = "-" ]; then
        # Get previous branch from git reflog (more reliable)
        local prev_branch
        prev_branch=$(command git reflog show --no-abbrev -1 HEAD@{1} 2>/dev/null | grep -oE 'checkout: moving from [^ ]+ to [^ ]+' | sed 's/checkout: moving from //' | awk '{print $1}')

        # Alternative: try to get from ORIG_HEAD if available
        if [ -z "$prev_branch" ] || [ "$prev_branch" = "HEAD" ]; then
            if [ -f "$repo_root/.git/ORIG_HEAD" ]; then
                local orig_head
                orig_head=$(cat "$repo_root/.git/ORIG_HEAD" 2>/dev/null)
                prev_branch=$(command git name-rev --name-only "$orig_head" 2>/dev/null | sed 's/^.*\///')
            fi
        fi

        # If we found a previous branch, check if it has a worktree
        if [ -n "$prev_branch" ] && [ "$prev_branch" != "HEAD" ]; then
            # Check if previous branch has a worktree
            local worktree_path
            worktree_path=$(command git worktree list --porcelain 2>/dev/null | awk -v branch="refs/heads/$prev_branch" 'BEGIN {found=0} /^worktree / {wt=$2; getline} /^branch / {if ($2 == branch) {print wt; exit}}')

            if [ -n "$worktree_path" ] && [ -d "$worktree_path" ]; then
                echo "Switching to previous branch worktree: $worktree_path"
                cd "$worktree_path" || return 1
                return
            fi

            # Check .worktree directory
            local worktree_dir="$repo_root/.worktree"
            local target_path="$worktree_dir/$prev_branch"
            if [ -d "$target_path" ]; then
                echo "Switching to previous branch worktree: $target_path"
                cd "$target_path" || return 1
                return
            fi
        fi

        # Try normal checkout - if it fails with worktree error, handle it
        local checkout_output
        checkout_output=$(command git checkout - "${args[@]}" 2>&1)
        local checkout_exit=$?

        if [ $checkout_exit -eq 0 ]; then
            return
        fi

        # Check if error mentions worktree
        if echo "$checkout_output" | grep -q "already used by worktree"; then
            # Extract branch name from error message
            local branch_name
            branch_name=$(echo "$checkout_output" | grep -oE "'.*' is already used" | sed "s/' is already used//" | sed "s/'//g")

            if [ -n "$branch_name" ]; then
                # Find the worktree for this branch
                local worktree_path
                worktree_path=$(command git worktree list --porcelain 2>/dev/null | awk -v branch="refs/heads/$branch_name" 'BEGIN {found=0} /^worktree / {wt=$2; getline} /^branch / {if ($2 == branch) {print wt; exit}}')

                if [ -n "$worktree_path" ] && [ -d "$worktree_path" ]; then
                    echo "Switching to previous branch worktree: $worktree_path"
                    cd "$worktree_path" || return 1
                    return
                fi

                # Check .worktree directory
                local worktree_dir="$repo_root/.worktree"
                local target_path="$worktree_dir/$branch_name"
                if [ -d "$target_path" ]; then
                    echo "Switching to previous branch worktree: $target_path"
                    cd "$target_path" || return 1
                    return
                fi
            fi
        fi

        # If we can't find worktree, show the error
        echo "$checkout_output" >&2
        return $checkout_exit
    fi

    # If --root flag is set, do normal checkout in root
    # Use --ignore-other-worktrees to allow checkout even if branch is in a worktree
    if [ $checkout_in_root -eq 1 ]; then
        if [ -z "$branch" ]; then
            command git checkout --ignore-other-worktrees "${args[@]}" 2>/dev/null || command git checkout "${args[@]}"
        else
            command git checkout --ignore-other-worktrees "${args[@]}" "$branch" 2>/dev/null || command git checkout "${args[@]}" "$branch"
        fi
        return
    fi

    # If -b flag is used, create a worktree for the new branch
    if [ $create_branch -eq 1 ] && [ -n "$branch" ]; then
        local worktree_dir="$repo_root/.worktree"
        local target_path="$worktree_dir/$branch"

        # Convert to absolute path to avoid issues when running from a worktree
        if [[ "$target_path" != /* ]]; then
            target_path=$(cd "$(dirname "$target_path")" 2>/dev/null && pwd)/$(basename "$target_path")
        fi

        if [ -d "$target_path" ]; then
            echo "Worktree already exists at: $target_path"
            cd "$target_path" || return 1
            return
        fi

        # Create new worktree with the new branch
        mkdir -p "$worktree_dir" 2>/dev/null
        echo "Creating worktree for new branch: $branch"

        # Get the starting point (current branch or HEAD)
        local start_point
        start_point=$(command git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")

        if command git worktree add -b "$branch" "$target_path" "$start_point" 2>/dev/null; then
            echo "Created and switching to worktree: $target_path"
            cd "$target_path" || return 1
            return
        else
            echo "Failed to create worktree, falling back to normal checkout"
            # Fall through to normal checkout below
        fi
    fi

    # Use fzf to select branch (if no branch provided, or if branch provided use it as query)
    local fzf_query=""
    local use_fzf=0
    if [ -z "$branch" ]; then
        # No branch provided - always use fzf
        use_fzf=1
        # #region agent log
        echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"B\",\"location\":\"functions.zsh:399\",\"message\":\"no branch provided, use_fzf=1\",\"data\":{},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
        # #endregion
    elif [ $create_branch -eq 0 ] && [ $checkout_in_root -eq 0 ]; then
        # Branch provided - check if it exists exactly, otherwise use as fzf query
        if command git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null || command git show-ref --verify --quiet "refs/remotes/origin/$branch" 2>/dev/null; then
            # Branch exists - don't use fzf, proceed with checkout
            use_fzf=0
        else
            # Branch doesn't exist - use as fzf query to filter
            fzf_query="$branch"
            branch=""
            use_fzf=1
        fi
    fi

    if [ $use_fzf -eq 1 ]; then
        # #region agent log
        echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"D\",\"location\":\"functions.zsh:413\",\"message\":\"entering fzf block\",\"data\":{\"is_tty\":\"$([ -t 0 ] && echo 1 || echo 0)\"},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
        # #endregion
        if ! command -v fzf >/dev/null 2>&1; then
            if [ -n "$fzf_query" ]; then
                # If query provided but no fzf, try direct checkout
                branch="$fzf_query"
            else
                echo "fzf not found, falling back to git checkout"
                command git checkout "${args[@]}"
                return
            fi
        elif [ ! -t 0 ] || [ ! -t 1 ]; then
            # Not in an interactive terminal - can't use fzf
            if [ -n "$fzf_query" ]; then
                # If query provided, try direct checkout
                branch="$fzf_query"
            else
                echo "Not in an interactive terminal. Cannot use fzf." >&2
                echo "Please provide a branch name: git co <branch-name>" >&2
                return 1
            fi
        else
            # Debug: Log that we're about to use fzf
            # echo "DEBUG: About to use fzf, branches count will be checked" >&2
            # Optimized: Collect all branches in one pass using git for-each-ref (faster)
            # This is much faster than multiple git branch calls
            local all_branches_output
            all_branches_output=$(command git for-each-ref --format='%(refname:short)|%(refname)|%(objectname:short)' refs/heads/ refs/remotes/origin/ 2>/dev/null | grep -v 'HEAD$')
            # #region agent log
            echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"E\",\"location\":\"functions.zsh:428\",\"message\":\"branches collected\",\"data\":{\"all_branches_output_lines\":\"$(echo \"$all_branches_output\" | wc -l)\",\"first_branch\":\"$(echo \"$all_branches_output\" | head -1)\"},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
            # #endregion

            # Debug: Check if we got any branches
            if [ -z "$all_branches_output" ]; then
                # #region agent log
                echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"E\",\"location\":\"functions.zsh:432\",\"message\":\"no branches found in repository\",\"data\":{},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
                # #endregion
                echo "No branches found in repository" >&2
                return 1
            fi

            # Get worktree info in parallel (single call)
            local worktree_info
            worktree_info=$(command git worktree list --porcelain 2>/dev/null)

            # Parse worktrees into associative array (faster lookup)
            local -A worktree_map
            local current_wt_path=""
            while IFS= read -r line; do
                if [[ "$line" =~ ^worktree[[:space:]]+(.+)$ ]]; then
                    current_wt_path="${match[1]}"
                elif [[ "$line" =~ ^branch[[:space:]]+(.+)$ ]] && [ -n "$current_wt_path" ]; then
                    local branch_ref="${match[1]}"
                    local branch_name="${branch_ref#refs/heads/}"
                    worktree_map["$branch_name"]="$current_wt_path"
                    current_wt_path=""
                fi
            done <<< "$worktree_info"

            # Build branch list with format: branch_name|worktree_path|display_name
            local branches=()
            while IFS='|' read -r branch_name branch_ref commit_hash; do
                # Skip HEAD
                [[ "$branch_name" == "HEAD" ]] && continue

                # Remove origin/ prefix for remote branches
                local is_remote=0
                if [[ "$branch_ref" == refs/remotes/* ]]; then
                    branch_name="${branch_name#origin/}"
                    is_remote=1
                fi

                # Format as branch_name|worktree_path|display_name
                local worktree_path="${worktree_map[$branch_name]:-}"
                local display_name="$branch_name"
                if [ -n "$worktree_path" ]; then
                    display_name="$branch_name [worktree]"
                elif [ $is_remote -eq 1 ]; then
                    display_name="$branch_name [remote]"
                else
                    display_name="$branch_name [local]"
                fi
                branches+=("$branch_name|$worktree_path|$display_name")
            done <<< "$all_branches_output"
            # #region agent log
            echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"E\",\"location\":\"functions.zsh:490\",\"message\":\"branches array built\",\"data\":{\"branches_count\":${#branches[@]},\"first_branch\":\"${branches[1]}\"},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
            # #endregion

            if [ ${#branches[@]} -eq 0 ]; then
                # #region agent log
                echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"E\",\"location\":\"functions.zsh:494\",\"message\":\"no branches found in array\",\"data\":{},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
                # #endregion
                echo "No branches found" >&2
                return 1
            fi
            # #region agent log
            echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"D\",\"location\":\"functions.zsh:500\",\"message\":\"about to run fzf\",\"data\":{\"branches_count\":${#branches[@]},\"sample_branch\":\"${branches[1]}\"},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
            # #endregion

            # Build fzf command with bindings
            # Use awk to format display (show display_name) but keep full data for processing
            local fzf_cmd=(
                fzf
                --height 40%
                --reverse
                --border
                --delimiter '|'
                --with-nth=3
                --header="Select branch: Enter(checkout), Ctrl-D(remove), Ctrl-Y/Ctrl-C(copy path), Ctrl-X(open website), ?(help)"
                --preview-window=right:40%:wrap
                --preview='branch_info="{}"; branch_name=$(echo "$branch_info" | cut -d"|" -f1); worktree_path=$(echo "$branch_info" | cut -d"|" -f2); if [ -n "$worktree_path" ]; then echo "Branch: $branch_name"; echo "Worktree: $worktree_path"; command git -C "$worktree_path" log -1 --oneline --decorate 2>/dev/null || echo "No commits"; else command git log -1 --oneline --decorate "$branch_name" 2>/dev/null || echo "Branch: $branch_name"; fi'
                --bind "enter:accept"
                --bind "ctrl-d:execute-silent(branch_info=\"{}\"; worktree_path=\$(echo \"\$branch_info\" | cut -d\"|\" -f2); if [ -n \"\$worktree_path\" ]; then command git worktree remove \"\$worktree_path\" 2>/dev/null || command git worktree remove --force \"\$worktree_path\" 2>/dev/null; command git worktree prune 2>/dev/null; fi)+abort"
                --bind "ctrl-y:execute-silent(branch_info=\"{}\"; worktree_path=\$(echo \"\$branch_info\" | cut -d\"|\" -f2); if [ -n \"\$worktree_path\" ]; then echo -n \"\$worktree_path\" | xclip -sel clip 2>/dev/null; fi)+abort"
                --bind "ctrl-c:execute-silent(branch_info=\"{}\"; worktree_path=\$(echo \"\$branch_info\" | cut -d\"|\" -f2); if [ -n \"\$worktree_path\" ]; then echo -n \"\$worktree_path\" | xclip -sel clip 2>/dev/null; fi)+abort"
                --bind "ctrl-x:execute-silent(branch_info=\"{}\"; branch_name=\$(echo \"\$branch_info\" | cut -d\"|\" -f1); worktree_path=\$(echo \"\$branch_info\" | cut -d\"|\" -f2); repo_root=\"$repo_root\"; if [ -n \"\$worktree_path\" ] && [ -d \"\$worktree_path\" ]; then (cd \"\$worktree_path\" && git site 2>/dev/null &); elif [ -n \"\$repo_root\" ]; then (cd \"\$repo_root\" && git site 2>/dev/null &); fi)+abort"
                --bind '?:preview:echo "Help:\n\tEnter - Checkout branch\n\tCtrl-D - Remove worktree\n\tCtrl-Y/Ctrl-C - Copy worktree path to clipboard\n\tCtrl-X - Open branch website\n\tEsc - Cancel"'
            )

            # Add query if provided
            if [ -n "$fzf_query" ]; then
                fzf_cmd+=(--query "$fzf_query")
            fi

            local selected
            # Use command substitution directly - this works better in interactive terminals
            # fzf needs to write to the terminal, so we redirect stderr to /dev/tty
            # and capture stdout for the selection
            # #region agent log
            local branches_preview=$(printf '%s\n' "${branches[@]}" | head -3 | tr '\n' ';')
            echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"D\",\"location\":\"functions.zsh:545\",\"message\":\"executing fzf command\",\"data\":{\"branches_count\":${#branches[@]},\"branches_preview\":\"$branches_preview\"},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
            # #endregion
            selected=$(printf '%s\n' "${branches[@]}" | "${fzf_cmd[@]}" 2>/dev/tty)
            local fzf_exit_code=$?
            # #region agent log
            echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"D\",\"location\":\"functions.zsh:550\",\"message\":\"fzf exited\",\"data\":{\"fzf_exit_code\":$fzf_exit_code,\"selected\":\"$selected\"},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
            # #endregion

            # fzf returns 130 when canceled (Esc), 1 on error, 0 on selection
            if [ $fzf_exit_code -eq 130 ]; then
                # #region agent log
                echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"D\",\"location\":\"functions.zsh:545\",\"message\":\"fzf canceled by user\",\"data\":{},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
                # #endregion
                # User canceled fzf - this is normal, just return silently
                return 0
            elif [ $fzf_exit_code -ne 0 ] || [ -z "$selected" ]; then
                # #region agent log
                echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"D\",\"location\":\"functions.zsh:550\",\"message\":\"fzf failed or no selection\",\"data\":{\"fzf_exit_code\":$fzf_exit_code,\"selected_empty\":\"$([ -z \"$selected\" ] && echo 1 || echo 0)\"},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
                # #endregion
                # fzf failed or no selection
                if [ $fzf_exit_code -eq 2 ]; then
                    echo "fzf error: exit code 2 (terminal issue or invalid input)" >&2
                elif [ $fzf_exit_code -ne 130 ]; then
                    echo "fzf failed with exit code: $fzf_exit_code" >&2
                fi
                return 1
            fi

            # Extract branch name and worktree path (selected contains full format: branch|path|display)
            branch=$(echo "$selected" | cut -d"|" -f1)
            local selected_worktree_path=$(echo "$selected" | cut -d"|" -f2)

            # If worktree path was selected and exists, switch to it
            if [ -n "$selected_worktree_path" ] && [ -d "$selected_worktree_path" ]; then
                echo "Switching to existing worktree: $selected_worktree_path"
                cd "$selected_worktree_path" || return 1
                return
            fi
        fi
    fi

    # Now process the selected/explicit branch
    # Check if worktree exists for this branch
    local worktree_path
    worktree_path=$(command git worktree list --porcelain 2>/dev/null | awk -v branch="refs/heads/$branch" 'BEGIN {found=0} /^worktree / {wt=$2; getline} /^branch / {if ($2 == branch) {print wt; exit}}')

    if [ -n "$worktree_path" ] && [ -d "$worktree_path" ]; then
        echo "Switching to existing worktree: $worktree_path"
        cd "$worktree_path" || return 1
        return
    fi

    # Check if branch exists (local or remote) - skip if we're creating a new branch with -b
    if [ $create_branch -eq 0 ] && (command git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null || command git show-ref --verify --quiet "refs/remotes/origin/$branch" 2>/dev/null); then
        local worktree_dir="$repo_root/.worktree"
        local target_path="$worktree_dir/$branch"

        # Convert to absolute path to avoid issues when running from a worktree
        if [[ "$target_path" != /* ]]; then
            target_path=$(cd "$(dirname "$target_path")" && pwd)/$(basename "$target_path")
        fi

        if [ -d "$target_path" ]; then
            echo "Switching to existing worktree: $target_path"
            cd "$target_path" || return 1
            return
        fi

        # Create new worktree
        mkdir -p "$worktree_dir" 2>/dev/null
        echo "Creating worktree for branch: $branch"
        if command git worktree add "$target_path" "$branch" 2>/dev/null; then
            echo "Created and switching to worktree: $target_path"
            cd "$target_path" || return 1
            return
        else
            echo "Failed to create worktree, falling back to normal checkout"
        fi
    fi

    # Fall back to normal checkout
    if [ -n "$branch" ]; then
        # If we have -b flag, make sure it comes before the branch name
        if [ $create_branch -eq 1 ]; then
            # Reconstruct the command: -b flag should come before branch name
            command git checkout -b "$branch" "${args[@]}"
        else
            command git checkout "${args[@]}" "$branch"
        fi
    else
        command git checkout "${args[@]}"
    fi
}

# Create _git_co that delegates to implementation
# This will be overwritten by git_completion.zsh with a smart wrapper
function _git_co() {
    _git_co_impl "$@"
}

# Git command wrapper is now in git_wrapper.zsh
# It intercepts "git co" and uses worktree-aware checkout via _git_co()
