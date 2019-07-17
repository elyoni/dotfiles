#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

#sudo apt-get install tig -y

#Install the new version
sudo apt-get install unzip -y


mkdir ~/Downloads/tig
#wget -P ~/Downloads/tig "https://github.com/jonas/tig/archive/master.zip"
wget -P ~/Downloads/tig "https://github.com/jonas/tig/archive/tig-2.4.1.zip"
unzip ~/Downloads/tig/tig-2.4.1.zip -d ~/Downloads/tig/
cd ~/Downloads/tig/tig-2.4.1/
make
sudo make install
#make prefix=/usr/local
#sudo make install prefix=/usr/local

$DIR/install_link.sh
