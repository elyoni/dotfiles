# Bash completion for git-site

_git_site_ci_vars() {
    local ci_file repo_root git_dir sha cache_dir cache_file vars
    repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || return
    git_dir=$(git rev-parse --git-dir 2>/dev/null) || return
    ci_file="${repo_root}/.gitlab-ci.yml"
    [[ -f "$ci_file" ]] || return

    sha=$(md5sum "$ci_file" 2>/dev/null | cut -d' ' -f1) || return
    cache_dir="${git_dir}/git-site-ci-vars"
    cache_file="${cache_dir}/${sha}.txt"

    if [[ -f "$cache_file" ]]; then
        cat "$cache_file"
        return
    fi

    if grep -q '^variables:' "$ci_file" 2>/dev/null; then
        vars=$(grep -oE '^\s+[A-Z][A-Z0-9_]+\s*:' "$ci_file" | sed 's/^\s*//;s/\s*://')
    else
        local inc_files
        inc_files=$(grep -E '^\s+(-\s+)?/' "$ci_file" 2>/dev/null | sed 's/^\s*-\?\s*//')
        vars=""
        for inc in $inc_files; do
            local inc_path="${repo_root}/${inc#/}"
            [[ -f "$inc_path" ]] || continue
            vars+=$(grep -oE '^\s+[A-Z][A-Z0-9_]+\s*:' "$inc_path" | sed 's/^\s*//;s/\s*://')
        done
    fi

    vars=$(echo "$vars" | sort -u | grep -v '^$')
    mkdir -p "$cache_dir"
    rm -f "${cache_dir}/"*.txt 2>/dev/null
    echo "$vars" > "$cache_file"
    echo "$vars"
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
        COMPREPLY=($(compgen -W "mr pipeline pipeline-new pipeline-run --update --remote --file --help -h" -- "$cur")
                   $(compgen -f -- "$cur"))
    elif [ "${words[1]}" = "mr" ]; then
        COMPREPLY=($(compgen -W "--me --all --state --scope --help -h" -- "$cur"))
    elif [ "${words[1]}" = "pipeline" ]; then
        COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
    elif [ "${words[1]}" = "pipeline-new" ] || [ "${words[1]}" = "pipeline-run" ]; then
        COMPREPLY=($(compgen -W "--var --help -h" -- "$cur"))
    fi
}

complete -F _git_site git-site
