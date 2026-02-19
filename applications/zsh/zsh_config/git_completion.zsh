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

# git co: completion that avoids __git_remote_branch_names_noprefix (slow; can hang 9s+ and get killed).
# _git (system) calls _git-$words[1], i.e. _git-co (hyphen).
_git-co() {
  local curcontext=$curcontext state line ret=1
  declare -A opt_args
  _arguments -C -s \
    '-b[create new branch]: :__git_branch_names' \
    '-w[create new worktree and branch]: :__git_branch_names' \
    '-[switch to last branch/worktree]' \
    '*:: :->branch-or-path' && ret=0
  case $state in
    (branch-or-path)
      # Local branches only (no tree-ish, no remote) so completion is instant
      __git_branch_names && ret=0
      ;;
  esac
  return ret
}
# Keep _git_co for tests / backwards reference.
_git_co() {
  _git-co "$@"
}

# Explicitly tell completion system to use _git for git command
compdef _git git
