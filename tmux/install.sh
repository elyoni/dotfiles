#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

sudo apt-get install tmux -y
sudo apt-get install jq -y
ln -sf $DIR/tmux.conf $HOME/.tmux.conf
