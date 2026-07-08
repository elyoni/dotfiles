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
