#!/bin/bash
sudo apt-get install xprintidle -y

#ln -sf $(pwd)/printtime.sh $HOME/printtime.sh
#ln -sf $(pwd)/time_xprintidle $HOME/.time_xprintidlel
sudo ln -sf $(pwd)/time_xprintidle /usr/share/i3blocks/time_xprintidle
