#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ZSH="$HOME/.oh-my-zsh" 
export ZSH_CUSTOM="$ZSH/custom" 

function install_zsh
{
    sudo apt-get install zsh -y
    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

}

function install_plugin
{
    local plugin_path="$ZSH_CUSTOM/plugins"
    mkdir -p "$plugin_path"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugin_path/zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_path/zsh-autosuggestions"
}

function _smart_link
{
    # TODO: need to pull the name of the file and add it to the target
    local source=$1
    local target=$2
    local force=${3:-false}

    if [ ! -f $target ] || [ "$force" == "yes" ]; then
        echo Creating new link: ln -sf "$source" "$target"
        ln -sf "$source" "$target"
    else
        echo The link of: "$source" "$target" is alrady exits
    fi
    
}

function link_files
{
    echo ======= Link Files =======
    export -f _smart_link

    # Link zshrc
    _smart_link $PWD/zshrc $HOME/.zshrc yes

    # Link the settings files
    find zsh_config -name "*.zsh" -exec bash -c '_smart_link "$PWD/$0" "$ZSH_CUSTOM"' {} \;
    echo =======   End   =======
}

function install
{
    install_zsh
    link_files
}

function help # Show a list of functions
{
    grep "^function" $0
}

if [ $# -eq 0 ]; then
    help
else
    "$@"
fi

