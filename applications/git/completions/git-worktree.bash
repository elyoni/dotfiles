# Bash completion for git-worktree

_git_worktree() {
    local cur prev words cword
    _init_completion || return

    case "$prev" in
        add)
            __git_complete_refs
            ;;
        remove|rm|find)
            COMPREPLY=($(compgen -W "$(git worktree list --porcelain 2>/dev/null | awk '/^worktree / {print $2}')" -- "$cur"))
            ;;
        *)
            if [ "$cword" -eq 1 ]; then
                COMPREPLY=($(compgen -W "list add remove rm prune find current help --help -h" -- "$cur"))
            fi
            ;;
    esac
}

complete -F _git_worktree git-worktree
