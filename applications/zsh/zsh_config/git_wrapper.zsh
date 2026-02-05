# Git command wrapper to intercept "git co" and use worktree-aware checkout
# This function runs in the current shell, allowing cd to work properly
function git() {
    # #region agent log
    echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"A\",\"location\":\"git_wrapper.zsh:3\",\"message\":\"git() function entry\",\"data\":{\"args\":\"$@\",\"funcstack\":\"${funcstack[@]}\"},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
    # #endregion
    # Check if we're in a completion context
    # zsh completion functions start with underscore
    # compstate is an associative array, check if it exists with $+compstate
    local in_completion=0
    if [[ "${funcstack[1]}" == "_"* ]] || [[ "${funcstack[2]}" == "_"* ]]; then
        in_completion=1
    fi

    # Check if compstate exists (it's an associative array in zsh)
    if (( $+compstate )); then
        in_completion=1
    fi

    # #region agent log
    echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"C\",\"location\":\"git_wrapper.zsh:20\",\"message\":\"completion check result\",\"data\":{\"in_completion\":$in_completion,\"funcstack1\":\"${funcstack[1]}\",\"funcstack2\":\"${funcstack[2]}\"},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
    # #endregion

    # If in completion context, always use command git to avoid interfering with completion
    if [ $in_completion -eq 1 ]; then
        # #region agent log
        echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"C\",\"location\":\"git_wrapper.zsh:25\",\"message\":\"bypassing wrapper - completion context\",\"data\":{},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
        # #endregion
        command git "$@"
        return
    fi

    if [ "$1" = "co" ]; then
        # #region agent log
        echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"A\",\"location\":\"git_wrapper.zsh:32\",\"message\":\"intercepting git co, calling _git_co\",\"data\":{\"remaining_args\":\"${@:2}\"},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
        # #endregion
        shift
        _git_co "$@"
        local exit_code=$?
        # #region agent log
        echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"A\",\"location\":\"git_wrapper.zsh:36\",\"message\":\"_git_co returned\",\"data\":{\"exit_code\":$exit_code},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
        # #endregion
        return $exit_code
    else
        # #region agent log
        echo "{\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"A\",\"location\":\"git_wrapper.zsh:40\",\"message\":\"not git co, using command git\",\"data\":{},\"timestamp\":$(date +%s%3N)}" 2>&1 | tee -a /home/yonie@liveu.tv/.dotfiles/.cursor/debug.log >/dev/null
        # #endregion
        command git "$@"
    fi
}
