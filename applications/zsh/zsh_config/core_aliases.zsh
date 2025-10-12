#!/usr/bin/env zsh
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias l='ls -lah --color=auto'
alias ls='ls --color=auto'
alias ll='ls --color=auto'
alias dotf='cd ${HOME}/.dotfiles'
alias dotfiles='cd ${HOME}/.dotfiles'

command -v ranger > /dev/null && alias rr="ranger"
command -v gitui > /dev/null && alias gi="gitui"
command -v batcat > /dev/null && alias bat="batcat"
command -v fdfind > /dev/null && alias fd="fdfind"


alias clp='xclip -sel clip'
alias pwdcp='pwd | xclip -sel clip'
