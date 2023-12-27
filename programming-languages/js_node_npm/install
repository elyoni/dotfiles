#!/usr/bin/env bash

NVM_VERSION=0.39.5
function _install_package_dependencies()
{
    sudo apt-get install curl -y
}


function _install_nvm()
{
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v"${NVM_VERSION}"/install.sh | bash
}

function _install_node()
{
    nvm install --lts
}

function install()
{
    _install_nvm
    _install_node
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
