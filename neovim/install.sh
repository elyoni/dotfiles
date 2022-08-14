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
    sudo npm install -g neovim
    # sudo npm cache clean -f
    # sudo npm install -g n
    # sudo n stable
    echo ======== End ========
}

function install_grammer_plugin_dependecy
{
    # TODO, need to verify ubuntu version, assume ubuntu version 20.04
    sudo apt-get install default-jre              # version 2:1.11-72, or
    # sudo apt install openjdk-11-jre-headless  # version 11.0.7+10-3ubuntu1
    # sudo apt install openjdk-13-jre-headless  # version 13.0.3+3-1ubuntu2
    # sudo apt install openjdk-14-jre-headless  # version 14.0.1+7-1ubuntu1
    # sudo apt install openjdk-8-jre-headless   # version 8u252-b09-1ubuntu1

    sudo apt-get install unzip
}


function install_ripgrap  # Install ripgrep
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
}

function install_neovim()  # Install neovim
{
    echo ======= Install Neovim =======
    ### Installation
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt update
    sudo apt-get install neovim -y
    sudo apt-get install python3-pip -y

    sudo pip3 install --upgrade neovim
    sudo pip3 install pynvim


    sudo ln -sf /usr/bin/nvim /usr/bin/vim
    sudo ln -sf /usr/bin/nvim /usr/bin/vi
    echo ======= End  =======
}

function install_autocomplete
{
    sudo apt-get install npm -y
    # Install Nodejs 16
    ## Install nvm to install nodejs
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    source $HOME/.zshrc
    nvm install v16

    sudo npm install -g pyright

    sudo npm install -g bash-language-server
    sudo pip3 install python-language-server
    sudo pip3 install cmake-language-server
    sudo apt-get install clangd-9 -y
}

function install_plug_plugin_legacy
{
    local autoload_dir="$NEOVIM_PATH/autoload"
    echo ======= Install Neovim Plugins =======
    ### nvim plugins
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    nvim +PlugInstall +PlugClean! +qall
    echo ======= End  =======
}

function install_plug_plugin_new
{
    # I am replacing the plugin manager because I want it to be writen in lua
    git clone https://github.com/savq/paq-nvim.git \
        "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim
    nvim +PackerInstall +qall
}

function install_asciidoc_dependencies
{
    sudo apt-get install ruby-full rubygems -y
    sudo gem install asciidoctor
    sudo gem install asciidoctor-diagram
    sudo gem install asciidoctor-rouge
    
    
}

function link_neovim_files  # Link neovim files(color + init.vim)
{
    ln -sf $DIR/nvim $HOME/.config
}

function install  # Main function, this function install everything 
{
    install_neovim
    #install_vim
    install_ripgrap
    link_neovim_files
    install_packages
    install_grammer_plugin_dependecy
    install_plug_plugin_legacy 
    install_autocomplete
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

