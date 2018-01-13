#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

sudo apt-get install xprintidle -y

#ln -sf $(pwd)/printtime.sh $HOME/printtime.sh
#ln -sf $(pwd)/time_xprintidle $HOME/.time_xprintidlel
sudo ln -sf $DIR/time_xprintidle /usr/share/i3blocks/time_xprintidle
