[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Optimized: use zsh $+commands instead of which subprocess
if (( $+commands[fdfind] )); then
    export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --color=always  --exclude .git'
    export FZF_DEFAULT_OPTS="--ansi"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
