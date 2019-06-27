#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

sudo apt-get install xsel
ln -sf $DIR/rc.conf $HOME/.config/ranger/rc.conf
ln -sf $DIR/rifle.conf $HOME/.config/ranger/rifle.conf
ln -sf $DIR/scope.sh $HOME/.config/ranger/scope.sh
echo Done
