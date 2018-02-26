#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

sudo apt-get install tig -y

ln -sf $DIR/tigrc $HOME/.tigrc
