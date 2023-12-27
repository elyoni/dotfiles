#!/usr/bin/env bash

function install_rustup(){
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

function zsh_autocompletion(){
    local zfunc_path=$HOME/.zfunc
    [ ! -d "${zfunc_path}" ] && mkdir -p "${zfunc_path}"
    rustup completions zsh > "${zfunc_path}"/_rustup
    rustup completions zsh cargo > "${zfunc_path}"/_cargo
}

function install()
{
    install_rustup
    zsh_autocompletion
}

function verify()
{
    :
}

function help() # Show a list of functions
{
    awk '/^function / && ! /^function _/' "$0"
}

if [ $# -eq 0 ]; then
    help
else
    "$@"
fi
