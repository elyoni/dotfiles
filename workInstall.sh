#!/bin/bash

# ======== apt-get =======
# === Pip python ===
echo "Install Python"
sudo apt-get instal python-pip -y
sudo apt-get instal python3-pip -y
pip install --upgrade pip
pip3 install --upgrade pip

## To connect the clipboard of the neovim and the linux
sudo apt-get install xclip -y

echo "Install VIM & VIMRC"
sh vim/install.sh

echo "TMUX Configurion"
sh tmux/install.sh
