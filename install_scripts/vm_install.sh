#!/usr/bin/env bash

source 09common

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)

summary=""

install_package "Ripgrep" "${DIR}"/../applications/ripgrep
install_package "Neovim" "${DIR}"/../neovim
install_package "Fzf" "${DIR}"/../applications/fzf
install_package "Zsh" "${DIR}"/../applications/zsh
install_package "tig" "${DIR}"/../applications/tig
install_package "Ranger" "${DIR}"/../applications/ranger

echo "${summary}"
