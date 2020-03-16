#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

function install_zsh()
{
    sudo apt-get install zsh -y
    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

}

function link_files()
{
    echo ======= Link Files =======
    ln -sf $DIR/.zshrc $HOME/.zshrc
    ln -sf $DIR/yoni.zsh-theme $HOME/.oh-my-zsh/themes/yoni.zsh-theme
    echo =======   End   =======
}

function install()
{
    install_zsh
    link_files
}

"$@"
