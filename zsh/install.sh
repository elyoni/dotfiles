#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ZSH="$HOME/.oh-my-zsh" 

# ZSH_CUSTOM the path of the user settings
export ZSH_CUSTOM="$HOME/.config/zsh" 

function zsh
{
    sudo apt-get install zsh -y
    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

}

function plugin
{
    local plugin_path="$ZSH_CUSTOM/plugins"
    local github_url="https://github.com/zsh-users"
    mkdir -p "$plugin_path"
    git clone "$github_url/zsh-syntax-highlighting" "$plugin_path/zsh-syntax-highlighting"
    git clone "$github_url/zsh-autosuggestions" "$plugin_path/zsh-autosuggestions"
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
    echo ======= Start Link Files =======
    # export -f _smart_link

    # Link zshrc
    ln -sf "$PWD/zshrc" "$HOME/.zshrc"
    # Link configs
    ln -sf "$PWD/zsh_config" "$HOME/.config/zsh"
    echo ======= End Link Files =======
}

function install
{
    zsh
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

