#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

#sudo apt-get install tig -y
function link_files()
{
    echo ======= link_files =======
    ln -sf $DIR/tigrc $HOME/.tigrc
    echo =======    end    =======
}

function install_tig()
{
    sudo apt-get install libncurses5-dev libncursesw5-dev -y
    VERSION="tig-2.5.0" 
    echo ======= install tig Version $VERSION  =======
    DOWNLOAD_PATH=$HOME/Downloads/apps/tig
    mkdir -p ${DOWNLOAD_PATH}
    wget -P ${DOWNLOAD_PATH} https://github.com/jonas/tig/releases/download/$VERSION/$VERSION.tar.gz
    tar -C ${DOWNLOAD_PATH} -xvf $DOWNLOAD_PATH/${VERSION}.tar.gz
    cd ${DOWNLOAD_PATH}/${VERSION}
    make prefix=/usr/local
    sudo make install prefix=/usr/local
    cd -
    echo ======= End  =======
}

function install()
{
    install_tig
    link_files
}

"$@" 
