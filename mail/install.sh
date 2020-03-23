#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

function install_davmail()
{
    sudo apt-get install default-jre -y
    sudo apt install $DIR/davmail_5.4.0-3135-1_all.deb 
}

function install_evolution()
{
    sudo add-apt-repository ppa:gnome3-team/gnome3-staging
    sudo apt-get update
    sudo apt-get install evolution
}

function remove_evolution()
{
    ppa-purge gnome3-team/gnome3-staging
    ppa-purge gnome3-team/gnome3
}

function install()
{
    install_davmail
    install_evolution
}

"$@"
