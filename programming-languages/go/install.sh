#!/usr/bin/env bash

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "$DIR" && pwd)

GOVERSION=1.21.4
INSTALL_DIR_BASE=/usr/local
INSTALL_DIR=${INSTALL_DIR_BASE}/go

function _remove_old_version()
{
    rm -rf $INSTALL_DIR
}

function _install_go()
{
    wget https://go.dev/dl/go${GOVERSION}.linux-amd64.tar.gz
    if [ -f ${INSTALL_DIR} ]; then
        _remove_old_version
    fi

    sudo tar -C $INSTALL_DIR_BASE -xzf go${GOVERSION}.linux-amd64.tar.gz

    rm go${GOVERSION}.linux-amd64.tar.gz
}

function install()
{
    _install_go
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
