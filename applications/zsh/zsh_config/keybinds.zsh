bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Alt+Right / Alt+Left -> jump by word (instead of falling through to
# vi-mode visual selection when the escape sequence is unrecognized)
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[f" forward-word
bindkey "^[b" backward-word


bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-v' edit-command-line
