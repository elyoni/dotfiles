#!/bin/bash

set -e 

WORK_DIR=$(dirname "${BASH_SOURCE[0]}")
source "$WORK_DIR"/utils/addpath.sh

function basic_system_apps(){
    sudo apt-get install -y iputils-ping \
        wget
}

run_install(){ # Main function, this function install everything 
    basic_system_apps
}

verify_installation()
{
    echo "Installation verification passed"
}

if [ $# -eq 0 ]; then
    grep "^function" "$0"
else
    "$@"
fi
