#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)


function install_packages() # Install additional package for neovim
{
    ## To connect the clipboard of the neovim and the linux
    echo ====== Install additional packages =====
    sudo apt-get install xclip -y
    sudo apt-get install curl -y
    sudo apt-get install ctags -y
    sudo apt-get install pep8 -y

    # Need for th coc.vim
    sudo apt-get install npm -y
    sudo npm cache clean -f
    sudo npm install -g n
    sudo n stable
    echo ======== End ========
}

function install_ripgrap()  # Install ripgrep
{
    local res
    local download_url
    local file_name

    # Tools to download the latest version
    sudo apt-get install jq -y
    sudo apt-get install curl -y

    DOWNLOAD_PATH=$HOME/Downloads/apps/ripgrep
    mkdir -p ${DOWNLOAD_PATH}

    # Find the latest release for deb
    res=$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq -r '.assets[] | select(.name | contains("deb"))')
    download_url=$(jq -r .browser_download_url <<< "$res")
    file_name=$(jq -r .name <<< "$res")

    wget -P "${DOWNLOAD_PATH}" "$download_url"
    sudo apt install "${DOWNLOAD_PATH}/$file_name"
}

function install_vim()  # Install vim, not in-used
{
    # ======= vim =======
    ## Installation
    sudo apt-get install vim -y

    ## vim plugins
    sudo apt-get install curl -y #For the plugins
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ### Link vimrc and color
    ln -sf $DIR/init.vim $HOME/.vimrc
    mkdir -p $HOME/.vim/
    ln -sf $DIR/colors $HOME/.vim/colors

    ### lua suppurt
    #sudo apt-get install vim-nox -y
    #sudo apt-get install vim-gtk -y
    #sudo apt-get install vim-gnone -y
    #sudo apt-get install vim-athena -y
}

function install_neovim()  # Install neovim
{
    echo ======= Install Neovim =======
    ### Installation
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt update
    sudo apt-get install neovim -y
    sudo apt-get install python3-pip -y

    sudo pip2 install --upgrade neovim
    sudo pip3 install --upgrade neovim

    sudo ln -sf /usr/bin/nvim /usr/bin/vim
    sudo ln -sf /usr/bin/nvim /usr/bin/vi
    echo ======= End  =======
}

function install_neovim_plugins()  # Install neovim plugins
{
    echo ======= Install Neovim Plugins =======
    ### nvim plugins
    mkdir ~/.config/nvim/autoload/ -p
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    nvim +PlugInstall +PlugClean! +qall
    echo ======= End  =======
}

function link_neovim_files()  # Link neovim files(color + init.vim)
{
    ### Link vimrc and color
    mkdir -p $HOME/.config/nvim/
    ln -sf $DIR/init.vim $HOME/.config/nvim/init.vim
    ln -sf $DIR/colors $HOME/.config/nvim/colors
}

function install()  # Main function, this function install everything 
{
    install_neovim
    install_vim
    install_ripgrap
    link_neovim_files
    install_packages
    install_neovim_plugins
}

function help() # Show a list of functions
{
    grep "^function" $0
}

if [ $# -eq 0 ]; then
    help
else
    "$@"
fi

