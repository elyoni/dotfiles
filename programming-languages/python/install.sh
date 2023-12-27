#!/usr/bin/env bash


#Install pip from the official site.
#  Download the file get-pip.py from the official site.
#  Install it with python3 get-pip.py.
#  And install python venv, the version is the installed python version.
function install_pip()
{
    wget https://bootstrap.pypa.io/get-pip.py
    python3 get-pip.py
    python3 -m pip install --user virtualenv
    rm get-pip.py
}

#Install pipx from an




function install_pipx()
{
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
}

function install()
{
    install_pip
    install_pipx
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
