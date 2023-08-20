#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

NEOVIM_VERSION="0.9.1"
INSTALLION_DIR="${HOME}/.local"

function install_packages() # Install additional package for neovim
{
    ## To connect the clipboard of the neovim and the linux
    echo ====== Install additional packages =====
    sudo apt-get update
    sudo apt-get install -y xclip \
        curl \
        exuberant-ctags \
        tar \
        git
    echo ======== End ========
}

function verify()
{
    local neovim_installed_version="${NEOVIM_VERSION}"
    local neovim_current_version
    neovim_current_version=$(nvim --version | grep -e "v[0-9]" |  sed -e 's/^.*v\(.*\)/\1/g')
    if [[ ! -f $( which nvim ) ]]; then
        return 1
    fi



    if [[ "${neovim_current_version}"  == "${neovim_installed_version}" ]]; then
        return 0
    else
        return 1
    fi
}

function install_neovim()
{
    local download_path="/tmp/download/neovim"
    local file_name="nvim-linux64.tar.gz"
    local neovim_version="${NEOVIM_VERSION}"
    local download_url="https://github.com/neovim/neovim/releases/download/v${neovim_version}/${file_name}"
    
    # Clean folder if exits
    [ -d "${download_path}" ] && rm -rf "${download_path}"

    # Download file
    curl -fLo "${download_path}/${file_name}" --create-dirs "${download_url}"
    
    mkdir -p "${INSTALLION_DIR}"

    tar xzvf "${download_path}/${file_name}" --directory "${download_path}" --strip-components=1 -C "${INSTALLION_DIR}"
}


function install_asciidoc_dependencies
{
    sudo apt-get install ruby-full rubygems -y
    sudo gem install asciidoctor
    sudo gem install asciidoctor-diagram
    sudo gem install asciidoctor-rouge
}

function link_neovim_files  # Link neovim files(color + init.vim)
{
    ln -sf $DIR/nvim $HOME/.config
    ln -sf ${HOME}/.local/bin/nvim ${HOME}/.local/bin/vim
    ln -sf ${HOME}/.local/bin/nvim ${HOME}/.local/bin/vi
}

function install_plugins
{
    nvim +Lazy +qall
} 

function install  # Main function, this function install everything 
{
    install_packages
    install_neovim
    link_neovim_files
    install_plugins
}

function qinst
{
    if ! verify_installation; then
        install
    else
        echo "Neovim is already install"
    fi

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

