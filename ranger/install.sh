#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)


function install_application()
{
    echo ====== Install Ranger + Packages =====
    sudo apt-get install ranger -y
    sudo apt-get install xsel -y
    sudo apt-get install dialog -y
    sudo apt-get install file -y
    echo ====== End =====
}

function link_files()
{
    echo ======= Link Files =======
    mkdir -p $HOME/.config/ranger
    ln -sf $DIR/rc.conf $HOME/.config/ranger/rc.conf
    ln -sf $DIR/rifle.conf $HOME/.config/ranger/rifle.conf
    ln -sf $DIR/scope.sh $HOME/.config/ranger/scope.sh
    echo =======   End   =======
}

function install()
{
    install_application
    link_files
}

"$@"
