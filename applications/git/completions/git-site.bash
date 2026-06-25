# Bash completion for git-site

_git_site() {
    local cur prev words cword
    _init_completion || return

    case "$prev" in
        --remote)
            __git_remotes
            return
            ;;
        --file)
            _filedir
            return
            ;;
        --state)
            COMPREPLY=($(compgen -W "opened merged closed" -- "$cur"))
            return
            ;;
        --scope)
            COMPREPLY=($(compgen -W "all assigned_to_me created_by_me" -- "$cur"))
            return
            ;;
    esac

    if [ "$cword" -eq 1 ]; then
        COMPREPLY=($(compgen -W "mr --update --remote --file --help -h" -- "$cur")
                   $(compgen -f -- "$cur"))
    elif [ "${words[1]}" = "mr" ]; then
        COMPREPLY=($(compgen -W "--me --all --state --scope --help -h" -- "$cur"))
    fi
}

complete -F _git_site git-site
