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

# Define completion function for git co
_git_co() {
    __git_branch_names
}

# Explicitly tell completion system to use _git for git command
# This is needed because we override the git function
compdef _git git







