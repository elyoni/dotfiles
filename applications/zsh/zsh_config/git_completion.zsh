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

# Branch names only; use compadd so branch names with '#' or ':' never touch _describe.
# Keep only branches that contain PREFIX (substring) so "mmh" matches *mmh*.
# -M 'r:|?=**': allow substring/fuzzy match so typed prefix can match anywhere in completion.
__git_co_branch_names() {
  local -a branches
  branches=(${${(f)"$(_call_program branchrefs command git for-each-ref --format='"%(refname:short)"' refs/heads 2>/dev/null)"}})
  if [[ -n "$PREFIX" ]]; then
    branches=(${(M)branches:#*${PREFIX}*})
  fi
  (( ${#branches} )) && compadd -M 'r:|?=**' -a branches
}

# git co: completion that avoids __git_remote_branch_names_noprefix (slow) and
# __git_branch_names descriptions (commit subjects with # or : break compadd).
# _git (system) calls _git-$words[1], i.e. _git-co (hyphen).
# Substring matcher so "mmh" matches *mmh* in branch names.
_git-co() {
  local curcontext=$curcontext state line ret=1
  declare -A opt_args
  zstyle ':completion:*:git-co:*' matcher-list 'r:|?=**'
  _arguments -C -s \
    '-b[create new branch]: :__git_co_branch_names' \
    '-w[create new worktree and branch]: :__git_co_branch_names' \
    '-[switch to last branch/worktree]' \
    '*:: :->branch-or-path' && ret=0
  case $state in
    (branch-or-path)
      __git_co_branch_names && ret=0
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
