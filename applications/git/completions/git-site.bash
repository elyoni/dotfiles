# Bash completion for git-site

_git_site_ci_vars() {
    local ci_file repo_root
    repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || return
    ci_file="${repo_root}/.gitlab-ci.yml"
    [[ -f "$ci_file" ]] || return
    grep -oE '^\s+[A-Z][A-Z0-9_]+\s*:' "$ci_file" 2>/dev/null | sed 's/^\s*//;s/\s*://' | sort -u
}

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
        --var)
            local vars
            vars=$(_git_site_ci_vars)
            if [[ "$cur" == *=* ]]; then
                : # no completion for values
            elif [[ -n "$vars" ]]; then
                COMPREPLY=($(compgen -W "$vars" -- "$cur"))
                COMPREPLY=("${COMPREPLY[@]/%/=}")
                compopt -o nospace
            fi
            return
            ;;
    esac

    if [ "$cword" -eq 1 ]; then
        COMPREPLY=($(compgen -W "mr pipeline --update --remote --file --help -h" -- "$cur")
                   $(compgen -f -- "$cur"))
    elif [ "${words[1]}" = "mr" ]; then
        COMPREPLY=($(compgen -W "--me --all --state --scope --help -h" -- "$cur"))
    elif [ "${words[1]}" = "pipeline" ]; then
        COMPREPLY=($(compgen -W "--var --help -h" -- "$cur"))
    fi
}

complete -F _git_site git-site
