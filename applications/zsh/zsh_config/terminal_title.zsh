# Set terminal window title to current dir (at prompt) or running command
_title_precmd() {
  print -n "\e]0;${PWD/#$HOME/~}\a"
}

_title_preexec() {
  local cmd="${1// */}"   # first word of command
  print -n "\e]0;${cmd}: ${PWD/#$HOME/~}\a"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _title_precmd
add-zsh-hook preexec _title_preexec
