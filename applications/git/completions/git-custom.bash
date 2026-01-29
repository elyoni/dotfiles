# Bash completion for custom git-* scripts
# This extends git completion to include custom scripts

_git_custom_scripts() {
    local IFS=$'\n'
    local scripts=()
    
    # Find all git-* scripts in PATH
    local path_dirs
    IFS=: read -ra path_dirs <<< "$PATH"
    
    for dir in "${path_dirs[@]}"; do
        if [ -d "$dir" ]; then
            for script in "$dir"/git-*; do
                if [ -x "$script" ] && [ -f "$script" ]; then
                    local script_name=$(basename "$script")
                    local subcommand="${script_name#git-}"
                    scripts+=("$subcommand")
                fi
            done
        fi
    done
    
    # Remove duplicates and sort
    printf '%s\n' "${scripts[@]}" | sort -u
}

# Hook into git completion
_git() {
    local cur prev words cword
    _init_completion || return
    
    # Get standard git completions
    local git_completions
    git_completions=$(__git_commands 2>/dev/null)
    
    # Get custom script completions
    local custom_scripts
    custom_scripts=$(_git_custom_scripts)
    
    # Combine and filter based on current word
    if [ "$cword" -eq 1 ]; then
        COMPREPLY=($(compgen -W "$git_completions $custom_scripts" -- "$cur"))
    else
        # For subcommands, use standard git completion
        __git_main "$@"
    fi
}

# Only override if git completion is available
if declare -f __git_main >/dev/null 2>&1; then
    complete -o bashdefault -o default -F _git git 2>/dev/null || true
fi
