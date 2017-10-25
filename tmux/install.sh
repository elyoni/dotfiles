#!/bin/bash
sudo apt-get install tmux -y
ln -s $(pwd)/tmux/tmux.conf $HOME/.tmux.conf
