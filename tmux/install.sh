#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)
function link_files()
{
    echo ======= Link Files =======
    ln -sf $DIR/tmux.conf $HOME/.tmux.conf
    echo =======   End   =======
}

function install_tmux_apt_get()
{
    echo ======= Install Tmux =======
    sudo apt-get install tmux -y
    sudo apt-get install jq -y
    echo ======= End  =======
}

function install_tmux_last()
{
    sudo apt-get install libevent-dev ncurses-dev build-essential bison pkg-config -y
    DOWNLOAD_PATH=$HOME/Downloads/apps/tmux
    VERSION="3.1-rc4"
    VERSION_ONLY="3.1"
    mkdir -p ${DOWNLOAD_PATH}
    wget -P ${DOWNLOAD_PATH} https://github.com/tmux/tmux/releases/download/${VERSION_ONLY}/tmux-${VERSION}.tar.gz
    tar -C ${DOWNLOAD_PATH} -zxf $DOWNLOAD_PATH/tmux-${VERSION}.tar.gz
    cd ${DOWNLOAD_PATH}/tmux-${VERSION}
    ./configure
    make && sudo make install
    cd -
}

function install()
{
    install_tmux
    link_files
}

"$@" 
