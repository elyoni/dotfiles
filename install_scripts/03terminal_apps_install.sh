#!/usr/bin/env bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)

source "${DIR}"/09common

summary=""

# Install ZSH first as other apps depend on directories it creates (.zfunc, etc.)
install_package "Zsh" "${DIR}"/../applications/zsh
install_package "Git" "${DIR}"/../applications/git
install_package "Neovim" "${DIR}"/../applications/neovim
install_package "Tmux" "${DIR}"/../applications/tmux
install_package "Ripgrep" "${DIR}"/../applications/ripgrep
install_package "Fzf" "${DIR}"/../applications/fzf
install_package "tig" "${DIR}"/../applications/tig
install_package "Ranger" "${DIR}"/../applications/ranger
install_package "Cheat" "${DIR}"/../applications/cheat
install_package "Direnv" "${DIR}"/../applications/direnv
install_package "Bat" "${DIR}"/../applications/bat
install_package "Docker" "${DIR}"/../applications/docker
install_package "Tusk" "${DIR}"/../applications/tusk


echo "${summary}"
