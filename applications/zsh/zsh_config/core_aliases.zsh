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


#alias clp='xclip -sel clip'
alias clp='xclip -selection clipboard -in -f'
alias pwdcp='pwd | xclip -sel clip'

# AppImage desktop entry creator
alias appimage-add="${HOME}/.dotfiles/scripts/appimage-desktop-entry.sh"

# Toggle screen gamma (xrandr --brightness) dim/reset
alias gamma-dim='xrandr --output "$(xrandr | grep " connected" | head -1 | cut -d" " -f1)" --brightness 0.4'
alias gamma-reset='xrandr --output "$(xrandr | grep " connected" | head -1 | cut -d" " -f1)" --brightness 1.0'
#
# Toggle whether closing the lid suspends the machine
alias lid-stay-awake="${HOME}/.dotfiles/scripts/lid-stay-awake.sh"
