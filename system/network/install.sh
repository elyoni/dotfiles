#!/usr/bin/env bash
function install_dns_resolvconf()
{
    sudo apt update
    sudo apt install resolvconf
}

function install()
{
    install_dns_resolvconf
}

function help # Show a list of functions
{
    grep "^function" $0
}

if [ $# -eq 0 ]; then
    help
else
    "$@"
fi
