#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

sudo apt-get install tmux -y
sudo apt-get install jq -y

$DIR/install_link.sh
