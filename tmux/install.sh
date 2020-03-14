#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)
function link_files()
{
    echo ======= Link Files =======
    ln -sf $DIR/tmux.conf $HOME/.tmux.conf
    echo =======   End   =======
}

function install_tmux()
{
    echo ======= Install Tmux =======
    sudo apt-get install tmux -y
    sudo apt-get install jq -y
    echo ======= End  =======
}

function install()
{
    install_tmux
    link_files
}

"$@" 
