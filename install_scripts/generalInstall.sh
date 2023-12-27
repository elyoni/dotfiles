#!/bin/bash

echo "General Install"

#=== Pyton ===
sudo apt-get install python -y
sudo apt-get install python3 -y
sudo apt-get install python-pip -y
sudo apt-get install python3-pip -y
pip install --upgrade pip
pip3 install --upgrade pip

#=== PDF Reader ===
sudo apt-get install okular -y

#=== Network tools ===
sudo apt install net-tools
sudo apt-get install arp-scan -y

#=== Browser ===
## === Firefox ===
sudo apt-get intall firefox -y

## === Chrome ===
chrome_deb="google-chrome-stable_current_amd64.deb"
wget https://dl.google.com/linux/direct/${chrome_deb}
sudo apt-get install ./${chrome_deb}
rm ${chrome_deb}



#=== ruby ===
sudo apt-get install ruby-full rubygems -y

#=== workrave ===
sudo apt install workrave -y

#== Curl ==
sudo apt-get install libcurl3 php5-curl -y


echo "Install i3"
bash $HOME/.dotfiles/i3/install.sh install

echo "Install neovim"
bash $HOME/.dotfiles/neovim/install.sh install

echo "Install Double Commander"
bash $HOME/.dotfiles/double_commander/install.sh

echo "Install tmux"
bash $HOME/.dotfiles/tmux/install.sh install

echo "Install git"
bash $HOME/.dotfiles/git/install.sh install

echo "Install tig"
bash $HOME/.dotfiles/tig/install.sh install

echo "Install mail"
bash $HOME/.dotfiles/mail/install.sh install

echo "Install ranger"
bash $HOME/.dotfiles/ranger/install.sh install

# === bluetooth ===
sudo apt-get install bluetooth bluez bluez-tools rfkill -y
# TO check if the bluetooth is blocked we can run
## code: sudo rfkill list
## if your device is blocked you can run
## code: sudo rfkill unblock bluetooth
## to start the bluetooth service run:
## code: sudo service bluetooth start

# === Enable change lang ===
sudo apt-get install gnome-tweaks -y
gsettings set org.gnome.desktop.input-sources xkb-options "['grp:ctrl_shift_toggle']"


# === SSH ===
sudo apt-get install sshfs -y
sudo apt-get install sshpass -y
sudo apt-get install openssh-server -y

# === Remote desktop ===
sudo apt-get install remmina -y
sudo apt-get install xtightvncviewer -y

# === Print Screen ===
sudo apt-get install flameshot -y


#=== Install keepassx ===
sudo apt-get install keepassx -y

#=== Torrent ===
sudo add-apt-repository --yes ppa:qbittorrent-team/qbittorrent-stable -y
sudo apt-get update
sudo apt-get install qbittorrent -y

#=== Libre Office ===
## to install libre office we need to install aptitude
sudo apt install aptitude -y
sudo aptitude install libreoffice -y

# === Font Copy ===
dotfile_dir=$( dirname $( cd $(dirname $0) && pwd ))
mkdir -p $HOME/.fonts
cp $dotfile_dir/fonts/* $HOME/.fonts/
