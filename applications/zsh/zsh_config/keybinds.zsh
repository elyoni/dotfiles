bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word


bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
