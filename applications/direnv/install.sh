#!/usr/bin/env bash

function _install_direnv(){
    curl -sfL https://direnv.net/install.sh | bash
}

function install(){
    _install_direnv
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
