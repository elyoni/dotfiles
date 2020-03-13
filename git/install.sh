#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

function link_files()
{
    echo ======= Link Files =======
    ln -sf $DIR/gitconfig $HOME/.gitconfig
    echo =======   End   =======
}

function install_meld()
{
    VERSION="meld-3.20.2" 
    echo ======= install meld version $VERSION =======
    LIB_VERSION=$(echo $VERSION | sed 's/meld-\([0-9]\+.[0-9]\+\).*/\1/')
    sudo apt-get install intltool itstool gir1.2-gtksource-3.0 libxml2-utils libgirepository1.0-dev
    mkdir -p $HOME/Downloads/apps/meld
    wget -P $HOME/Downloads/apps/meld https://download.gnome.org/sources/meld/$LIB_VERSION/${VERSION}.tar.xz
    tar -C $HOME/Downloads/apps/meld $HOME/Downloads/apps/meld/${VERSION}.tar.xz

    cd $HOME/Downloads/apps/meld/${VERSION}/  # Must install from the library
    sudo ./setup.py install --prefix=/usr
    cd -
    echo ======= End  =======
}

function install()
{
    install_meld
    link_files
}

"$@" 
