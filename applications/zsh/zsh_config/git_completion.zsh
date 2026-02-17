# Git completion setup
# This file should be sourced after compinit
# It extends git completion to include "co" subcommand (alias for checkout)

# Force load _git completion if not already loaded
(( $+functions[_git] )) || autoload -Uz +X _git

# Ensure _git_subcommands array exists
if (( ! $+_git_subcommands )); then
    typeset -ga _git_subcommands
fi

# Add "co" if not already present (alias for checkout)
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

# git co is aliased to checkout in gitconfig; use same completion as checkout
_git_co() {
    _git_checkout "$@"
}

# Explicitly tell completion system to use _git for git command
compdef _git git
