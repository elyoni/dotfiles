#!/usr/bin/env zsh
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias l='ls -lah --color=auto'
alias ls='ls --color=auto'
alias ll='ls --color=auto'

[ -f $(which ranger) ] && alias rr="ranger"
[ -f $(which gitui) ] && alias gi="gitui"

alias clp='xclip -sel clip'
alias pwdcp='pwd | xclip -sel clip'
