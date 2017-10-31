#!/bin/bash

## To connect the clipboard of the neovim and the linux
sudo apt-get install xclip -y

# ======= vim =======
### Installation
sudo apt-get install vim -y

### vim plugins
sudo apt-get install curl -y #For the plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
### Link vimrc and color
ln -sf $(pwd)/vim/.vimrc $HOME/.vimrc
ln -sf $(pwd)/vim/colors $HOME/.vim/colors

# ======= neovim =======
### Installation
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt-get install neovim
sudo apt-get install python3-pip
pip3 install --user --upgrade neovim
### nvim plugins
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

### lua suppurt
sudo apt-get install vim-nox -y
sudo apt-get install vim-gtk -y
sudo apt-get install vim-gnone -y
sudo apt-get install vim-athena -y

### Link vimrc and color
ln -sf $(pwd)/vim/.vimrc $HOME/.config/nvim/init.vim
ln -sf $(pwd)/vim/colors $HOME/.config/nvim/colors
