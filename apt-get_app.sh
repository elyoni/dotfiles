#!/bin/bash
#=== Pip pyton ===
sudo apt-get instal python-pip -y
pip install --upgrade pip


#=== Install Arduino ===
## After extracting the zip file enter the library and run ./install.sh
# Fix port permission
## sudo usermod -a -G dialout <username>
sudo usermod -a -G dialout johnny
# Add ESP8266 Support
## Enter the flowing link http://arduino.esp8266.com/stable/package_esp8266com_index.json


## Install Fritzing 
sudo apt-get install fritzing -y

#=== Libre Office ===
## to install libre office we need to install aptitude
sudo apt install aptitude -y
sudo aptitude install libreoffice -y

#=== vim ===
## vim
sudo apt-get install vim -y

### vim plugins
sudo apt-get install curl -y #For the plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
######### cp vimrc ~/

## Neovim
### Installation
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
pip install --user --upgrade neovim

## To connect the clipboard of the neovim and the linux
sudo apt-get install xclip -y

#=== Install double commander ===
sudo apt-get install doublecmd-qt -y

#=== Multimedia Software ===
## KDE N Live
sudo apt-get install kdenlive -y

## Mp3 player
#sudo apt-get install rhythmbox -y # I have tried and it wan't work good
sudo apt-get install clementine -y

## Gimp
sudo apt-get install gimp -y


#=== Install keepassx ===
sudo apt-get install keepassx -y
