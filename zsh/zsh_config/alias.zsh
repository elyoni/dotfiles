# ========= Aliases =============
alias py=python3.8

alias mini0="sudo minicom -D /dev/ttyUSB0 -C ~/projects/minicom0.log"
alias mini1="sudo minicom -D /dev/ttyUSB1 -C ~/projects/minicom1.log"

alias cdpman="cd ~/projects/sources/apps/pmanager"
alias cdcore="cd ~/projects/sources/apps/core"
alias cdbuildroot="cd ~/projects/buildroot"
alias cdtools="cd ~/projects/tools"
alias cdshell="cd ~/projects/tools/shell"
alias cdlab="cd ~/projects/lab/"
alias cdutils="cd ~/projects/tools/utils/"
alias cdproto="cd ~/projects/sources/libsuite/modules/proto/"
alias cdlibsuite="cd ~/projects/sources/libsuite/"
alias tm0="tmux a -t minicom0"
alias tm1="tmux a -t minicom1"
alias tm_jupiter="tm1"
alias tm_jj="tm0"
alias tt="tmux a -t test"
alias vm="vifm $PWD"
alias gip="source ~/projects/tools/env/zsh/update_ip.sh"
alias vi="nvim"
alias box="bash ${HOME}/.se_dotfiles/docker/box.sh"
alias ydl-mp3="youtube-dl --extract-audio --audio-format mp3"
if [[ -f $(where pulsemixer) ]]; then
    alias px="pulsemixer"
fi
