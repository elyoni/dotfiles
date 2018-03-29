#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

ln -sf $DIR/.zshrc $HOME/.zshrc
ln -sf $DIR/yoni.zsh-theme $HOME/.oh-my-zsh/themes/yoni.zsh-theme
