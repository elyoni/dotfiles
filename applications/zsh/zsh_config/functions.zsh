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

# Smart git checkout with worktree support
# Usage: co [branch-name] or git co [branch-name]
# Options:
#   --root, -r    Checkout in root folder instead of creating worktree
# If no branch provided, shows fzf menu with all branches (local, remote, worktrees)
# This function runs in the current shell, so cd works properly
function co() {
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
    git_common_dir=$(git rev-parse --git-common-dir 2>/dev/null)
    local repo_root=""
    
    if [ -n "$git_common_dir" ]; then
        if [ "$git_common_dir" = ".git" ]; then
            repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
        else
            repo_root=$(dirname "$git_common_dir" 2>/dev/null)
        fi
    else
        repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
    fi
    
    if [ -z "$repo_root" ]; then
        git checkout "$branch" "${args[@]}"
        return
    fi
    
    # Support "git co -" to switch back to previous branch
    if [ "$branch" = "-" ]; then
        # Get previous branch from git reflog (more reliable)
        local prev_branch
        prev_branch=$(git reflog show --no-abbrev -1 HEAD@{1} 2>/dev/null | grep -oE 'checkout: moving from [^ ]+ to [^ ]+' | sed 's/checkout: moving from //' | awk '{print $1}')
        
        # Alternative: try to get from ORIG_HEAD if available
        if [ -z "$prev_branch" ] || [ "$prev_branch" = "HEAD" ]; then
            if [ -f "$repo_root/.git/ORIG_HEAD" ]; then
                local orig_head
                orig_head=$(cat "$repo_root/.git/ORIG_HEAD" 2>/dev/null)
                prev_branch=$(git name-rev --name-only "$orig_head" 2>/dev/null | sed 's/^.*\///')
            fi
        fi
        
        # If we found a previous branch, check if it has a worktree
        if [ -n "$prev_branch" ] && [ "$prev_branch" != "HEAD" ]; then
            # Check if previous branch has a worktree
            local worktree_path
            worktree_path=$(git worktree list --porcelain 2>/dev/null | awk -v branch="refs/heads/$prev_branch" 'BEGIN {found=0} /^worktree / {wt=$2; getline} /^branch / {if ($2 == branch) {print wt; exit}}')
            
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
        checkout_output=$(git checkout - "${args[@]}" 2>&1)
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
                worktree_path=$(git worktree list --porcelain 2>/dev/null | awk -v branch="refs/heads/$branch_name" 'BEGIN {found=0} /^worktree / {wt=$2; getline} /^branch / {if ($2 == branch) {print wt; exit}}')
                
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
            git checkout --ignore-other-worktrees "${args[@]}" 2>/dev/null || git checkout "${args[@]}"
        else
            git checkout --ignore-other-worktrees "${args[@]}" "$branch" 2>/dev/null || git checkout "${args[@]}" "$branch"
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
        start_point=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")
        
        if git worktree add -b "$branch" "$target_path" "$start_point" 2>/dev/null; then
            echo "Created and switching to worktree: $target_path"
            cd "$target_path" || return 1
            return
        else
            echo "Failed to create worktree, falling back to normal checkout"
            # Fall through to normal checkout below
        fi
    fi
    
    # If no branch provided, use fzf to select one
    if [ -z "$branch" ]; then
        if ! command -v fzf >/dev/null 2>&1; then
            echo "fzf not found, falling back to git checkout"
            git checkout "$@"
            return
        fi
        
        # Optimized: Collect all branches in one pass using git for-each-ref (faster)
        # This is much faster than multiple git branch calls
        local all_branches_output
        all_branches_output=$(git for-each-ref --format='%(refname:short)|%(refname)|%(objectname:short)' refs/heads/ refs/remotes/origin/ 2>/dev/null | grep -v 'HEAD$')
        
        # Get worktree info in parallel (single call)
        local worktree_info
        worktree_info=$(git worktree list --porcelain 2>/dev/null)
        
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
        
        # Build branch list efficiently
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
            
            # Check if branch has worktree
            if [ -n "${worktree_map[$branch_name]}" ]; then
                branches+=("$branch_name [worktree: ${worktree_map[$branch_name]}]")
            elif [ $is_remote -eq 1 ]; then
                # Only add remote if not in worktree_map
                branches+=("$branch_name [remote]")
            else
                # Local branch without worktree
                branches+=("$branch_name [local]")
            fi
        done <<< "$all_branches_output"
        
        # Sort: worktrees first, then local, then remote
        local worktree_branches=()
        local local_branches=()
        local remote_branches=()
        
        for br in "${branches[@]}"; do
            if [[ "$br" == *"[worktree:"* ]]; then
                worktree_branches+=("$br")
            elif [[ "$br" == *"[local]"* ]]; then
                local_branches+=("$br")
            else
                remote_branches+=("$br")
            fi
        done
        
        local all_branches=("${worktree_branches[@]}" "${local_branches[@]}" "${remote_branches[@]}")
        
        if [ ${#all_branches[@]} -eq 0 ]; then
            echo "No branches found"
            return 1
        fi
        
        local selected
        # Use faster preview that doesn't run git log unless needed
        selected=$(printf '%s\n' "${all_branches[@]}" | fzf \
            --height 40% \
            --reverse \
            --border \
            --header="Select branch to checkout (worktrees shown first)" \
            --preview-window=right:40%:wrap \
            --preview='branch_name=$(echo {} | sed "s/ \[.*//"); git log -1 --oneline --decorate "$branch_name" 2>/dev/null || echo "Branch: $branch_name"')
        
        if [ -z "$selected" ]; then
            return 1
        fi
        
        # Extract branch name (remove [worktree: ...] or [local] or [remote] suffix)
        branch="${selected%% \[*}"
    fi
    
    # Now process the selected/explicit branch
    # Check if worktree exists for this branch
    local worktree_path
    worktree_path=$(git worktree list --porcelain 2>/dev/null | awk -v branch="refs/heads/$branch" 'BEGIN {found=0} /^worktree / {wt=$2; getline} /^branch / {if ($2 == branch) {print wt; exit}}')
    
    if [ -n "$worktree_path" ] && [ -d "$worktree_path" ]; then
        echo "Switching to existing worktree: $worktree_path"
        cd "$worktree_path" || return 1
        return
    fi
    
    # Check if branch exists (local or remote) - skip if we're creating a new branch with -b
    if [ $create_branch -eq 0 ] && (git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null || git show-ref --verify --quiet "refs/remotes/origin/$branch" 2>/dev/null); then
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
        if git worktree add "$target_path" "$branch" 2>/dev/null; then
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
            git checkout -b "$branch" "${args[@]}"
        else
            git checkout "${args[@]}" "$branch"
        fi
    else
        git checkout "${args[@]}"
    fi
}

# Override git command to intercept "git co" and use the co function
# This allows "git co branch" to work and change directory in current shell
function git() {
    if [ "$1" = "co" ]; then
        shift
        co "$@"
    else
        command git "$@"
    fi
}
