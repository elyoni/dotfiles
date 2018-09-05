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

#=== Browser ===
sudo apt-get install chromium-browser -y
sudo apt-get intall firefox -y

#== Curl ==
sudo apt-get install libcurl3 php5-curl -y

echo "Install i3"
bash $HOME/.dotfiles/i3/install.sh

echo "Install VIM & VIMRC"
bash $HOME/.dotfiles/vim/install.sh

echo "Install Double Commander"
bash $HOME/.dotfiles/double_commander/install.sh

echo "Install tmux"
bash $HOME/.dotfiles/tmux/install.sh

# === bluetooth === 
sudo apt-get install bluetooth bluez bluez-tools rfkill -y
# TO check if the bluetooth is blocked we can run
## code: sudo rfkill list
## if your device is blocked you can run
## code: sudo rfkill unblock bluetooth
## to start the bluetooth service run:
## code: sudo service bluetooth start
sudo apt-get install blueman -y
sudo apt-get install pulseaudio pavucontrol # To run the settings just run 'pavucontrol'


# === SSH ===
sudo apt-get install sshfs -y
sudo apt-get install sshpass -y

# === Print Screen ===
sudo apt-get install scrot -y


# === FZF ===
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# === Font Copy ===
dotfile_dir=$( dirname $( cd $(dirname $0) && pwd ))
mkdir -p $HOME/.fonts
cp $dotfile_dir/fonts/* $HOME/.fonts/

# === ZSH ===
sudo apt-get install zsh -y
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
