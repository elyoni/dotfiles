#!/usr/bin/env bash

function zsh_autocompletion(){
    local zfunc_path=$HOME/.zfunc
    [ ! -d ${zfunc_path} ] && mkdir -p "${zfunc_path}"
    rustup completions zsh > "${zfunc_path}"/_rustup
    rustup completions zsh cargo > "${zfunc_path}"/_cargo
}

echo WIP
