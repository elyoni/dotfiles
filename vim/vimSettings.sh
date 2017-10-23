#!/bin/bash
# === vim ===
## vim
sudo apt-get install vim -y

### vim plugins
sudo apt-get install curl -y #For the plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
### Link vimrc and color
ln -s $(pwd)/vim/.vimrc ~/.vimrc
ln -s $(pwd)/vim/colors ~/.vim/colors

# === neovim ===
### Installation
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt-get install neovim
sudo apt-get install python3-pip
pip3 install --user --upgrade neovim
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

### Link vimrc and color
ln -s $(pwd)/vim/.vimrc ~/.config/nvim/init.vim
ln -s $(pwd)/vim/colors ~/.config/nvim/colors
