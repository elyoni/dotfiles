# Git command wrapper: intercept "git co" and delegate to _git_co (worktree-aware checkout).
# Completion is handled by _git via compdef; in completion context we bypass so compsys sees "git co".
function git() {
    local in_completion=0
    [[ "${funcstack[1]}" == _* ]] || [[ "${funcstack[2]}" == _* ]] && in_completion=1
    (( $+compstate )) && in_completion=1

    if (( in_completion )); then
        command git "$@"
        return
    fi

    if [[ "$1" == "co" ]]; then
        shift
        _git_co_impl "$@"
        return $?
    fi

    command git "$@"
}
