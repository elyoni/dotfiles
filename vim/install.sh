#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)


## To connect the clipboard of the neovim and the linux
sudo apt-get install xclip -y

sudo apt-get install ctags -y

# ======= vim =======
### Installation
#sudo apt-get install vim -y

### vim plugins
#sudo apt-get install curl -y #For the plugins
#curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
#	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#### Link vimrc and color
#ln -sf $DIR/.vimrc $HOME/.vimrc
#ln -sf $DIR/colors $HOME/.vim/colors

# ======= neovim =======
### Installation
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt-get install neovim -y
sudo apt-get install python3-pip -y

#sudo pip2 install neovim
#sudo pip3 install neovim

#pip3 install --user --upgrade neovim
sudo pip2 install --upgrade neovim
sudo pip3 install --upgrade neovim

### nvim plugins
mkdir ~/.config/nvim/autoload/ -p
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


### lua suppurt
#sudo apt-get install vim-nox -y
#sudo apt-get install vim-gtk -y
#sudo apt-get install vim-gnone -y
#sudo apt-get install vim-athena -y

### Link vimrc and color
ln -sf $DIR/.vimrc $HOME/.config/nvim/init.vim
ln -sf $DIR/colors $HOME/.config/nvim/colors

sudo ln -sf /usr/bin/nvim /usr/bin/vim
sudo ln -sf /usr/bin/nvim /usr/bin/vi


sudo apt-get install pep8
