#!/bin/bash
sudo apt-get install tmux -y
ln -sf $(pwd)/tmux/tmux.conf $HOME/.tmux.conf
