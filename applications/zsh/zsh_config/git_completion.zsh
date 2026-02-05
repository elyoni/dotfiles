# Git completion setup
# This file should be sourced after compinit
# It extends git completion to include "co" subcommand

# Force load _git completion if not already loaded
(( $+functions[_git] )) || autoload -Uz +X _git

# Ensure _git_subcommands array exists
if (( ! $+_git_subcommands )); then
    typeset -ga _git_subcommands
fi

# Add "co" if not already present
if [[ -z ${_git_subcommands[(r)co]} ]]; then
    _git_subcommands+=(co)
fi

# Add "wtcd" if not already present
if [[ -z ${_git_subcommands[(r)wtcd]} ]]; then
    _git_subcommands+=(wtcd)
fi

# Add "wttest" for testing completion
if [[ -z ${_git_subcommands[(r)wttest]} ]]; then
    _git_subcommands+=(wttest)
fi

# Define completion function for git co
# This function is called by zsh's completion system when completing "git co"
# Renamed to avoid conflict with _git_co() execution function in functions.zsh
# We'll register it with compdef to make it work
_git_co_comp() {
    # Strict guard: Only run if we're definitely in a completion context
    # Check funcstack - completion functions are called from _git
    local in_completion=0

    # Must be called from _git or another completion function
    if [[ "${funcstack[1]}" == "_git" ]] || [[ "${funcstack[2]}" == "_git" ]]; then
        in_completion=1
    fi

    # If not in completion context, return immediately without touching compstate
    if [ $in_completion -eq 0 ]; then
        return 0
    fi

    # We're in completion context, proceed with completion
    # Check that completion helper functions exist
    if (( ! $+functions[_description] )) || (( ! $+functions[_wanted] )); then
        return 0
    fi

    # Use completion functions
    local expl
    if (( $+functions[__git_branch_names] )); then
        _description branch expl 'branch name'
        _wanted branch expl 'branch name' __git_branch_names
    elif (( $+functions[_git_branch_names] )); then
        _description branch expl 'branch name'
        _wanted branch expl 'branch name' _git_branch_names
    else
        # Fallback: use git branch command
        local branches
        branches=$(command git branch --format='%(refname:short)' 2>/dev/null | grep -v 'HEAD$')
        if [ -n "$branches" ]; then
            _description branch expl 'branch name'
            _wanted branch expl 'branch name' compadd -- ${(f)branches}
        fi
    fi
}

# Create _git_co wrapper that delegates based on context
# functions.zsh loads first and defines _git_co_impl() for execution
# This file loads second and overwrites _git_co() with a smart wrapper
_git_co() {
    # Check if we're in completion context
    local in_completion=0
    if [[ "${funcstack[1]}" == "_git" ]] || [[ "${funcstack[2]}" == "_git" ]]; then
        in_completion=1
    fi
    if (( $+compstate )); then
        in_completion=1
    fi
    
    if [ $in_completion -eq 1 ]; then
        # In completion context - use completion function
        _git_co_comp "$@"
    else
        # In execution context - use execution function from functions.zsh
        if (( $+functions[_git_co_impl] )); then
            _git_co_impl "$@"
        else
            # Fallback if execution function not loaded yet
            _git_co_comp "$@"
        fi
    fi
}

# Explicitly tell completion system to use _git for git command
compdef _git git
