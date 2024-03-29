#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)


function link() # Link regolith config files
{
    ln -sf "${DIR}/i3" "${HOME}/.config/regolith "
}

f

function verify() # Verify the installation
{
    :
}


function install()
{
    :
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
