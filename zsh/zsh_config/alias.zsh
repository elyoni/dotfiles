# ========= Aliases =============

alias mini0="sudo minicom -D /dev/ttyUSB0 -C ~/projects/minicom0.log"
alias mini1="sudo minicom -D /dev/ttyUSB1 -C ~/projects/minicom1.log"
alias svi="sudo -E nvim"
alias ssh='env TERM=xterm-256color ssh'

alias clp='xclip -sel clip'
alias pwdcp='pwd | xclip -sel clip'

alias cdpman="cd ~/projects/sources/apps/pmanager"
alias cdcore="cd ~/projects/sources/apps/core"
alias cdbuildroot="cd ~/projects/buildroot"
alias cdtools="cd ~/projects/tools"
alias cdshell="cd ~/projects/tools/shell"
alias cdlab="cd ~/projects/lab/"
alias cdutils="cd ~/projects/tools/utils/"
alias cdproto="cd ~/projects/sources/libsuite/modules/proto/"
alias cdlibsuite="cd ~/projects/sources/libsuite/"
alias gip="source ~/projects/tools/env/zsh/update_ip.sh"
alias vi="nvim"
alias rr="ranger"
alias tt="taskwarrior-tui"
alias ydl-mp3="youtube-dl --extract-audio --audio-format mp3"
if [[ -f $(where pulsemixer) ]]; then
    alias px="pulsemixer"
fi
