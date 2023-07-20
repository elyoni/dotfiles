#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export TMUX_CONFIG=${XDG_CONFIG_HOME}/tmux

function link_files()
{
    echo ======= Link Files =======
    mkdir -p "${TMUX_CONFIG}"
    ln -sf "$DIR"/tmux.conf "${TMUX_CONFIG}"/tmux.conf
    ln -sf "$DIR"/configs "${TMUX_CONFIG}"/configs
    echo =======   End   =======
}

function prepare_installation(){
    echo ======= Prepare for Tmux Install =======
    sudo apt-get install wget -y
    echo ======= End  =======
}

function install_tmux_apt_get()
{
    echo ======= Install Tmux =======
    sudo apt-get install tmux -y
    echo ======= End  =======
}

function install_tmux_packages()
{
    sudo apt-get install jq git -y
    sudo apt-get install xclip -y # For yank plugin

    # Install plugin manager
    git clone https://github.com/tmux-plugins/tpm "${TMUX_CONFIG}"/plugins/tpm
}

function install_tmux_last()
{
    sudo apt-get install libevent-dev ncurses-dev build-essential bison pkg-config -y
    DOWNLOAD_PATH=$HOME/Downloads/apps/tmux
    VERSION="3.3a"
    # VERSION_ONLY=$(echo $VERSION | sed -e 's/^\([0-9]\+\.[0-9]\+\).*/\1/')
    mkdir -p "${DOWNLOAD_PATH}"
    wget -P "${DOWNLOAD_PATH}" https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
    tar -C "${DOWNLOAD_PATH}" -zxf "${DOWNLOAD_PATH}"/tmux-${VERSION}.tar.gz
    pushd "${DOWNLOAD_PATH}"/tmux-${VERSION} || return 
    ./configure
    make && sudo make install
    popd || return
}

function install()
{
    prepare_installation
    install_tmux_last
    link_files
    install_tmux_packages
}

"$@" 
