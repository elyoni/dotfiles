# Bash completion for git-delete

_git_delete() {
    local cur prev words cword
    _init_completion || return

    case "$prev" in
        --force-worktree|-h|--help)
            return
            ;;
        *)
            if [[ "$cur" != -* ]]; then
                __git_complete_refs
            else
                COMPREPLY=($(compgen -W "--force-worktree --help -h" -- "$cur"))
            fi
            ;;
    esac
}

complete -F _git_delete git-delete
