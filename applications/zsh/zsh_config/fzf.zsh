[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -f $(which fdfind) ]; then
    export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --color=always  --exclude .git'
    export FZF_DEFAULT_OPTS="--ansi"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
