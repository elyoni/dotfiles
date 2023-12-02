#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)

function _link() # Link regolith folder to ~/.config/regolith3
{
    ln -s "${DIR}/regolith3" "${HOME}/.config/regolith3"
}

function verify() # Verify the installation
{
    :
}


function install()
{
    _link
}

function help # Show a list of functions
{
    awk '/^function / && ! /^function _/' "$0"
}

if [ $# -eq 0 ]; then
    help
else
    "$@"
fi
