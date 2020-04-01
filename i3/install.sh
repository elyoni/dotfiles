#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

function application_install()
{
    echo ====== Start Application install =======
    echo ====== Install i3 =======
    sudo apt-get install i3 -y

    # ===== Install modules for i3 =====
    # Install an alternative for i3status
    echo ====== Install i3blocks =======
    sudo apt-get install i3blocks -y

    # Change notification app
    sudo apt install notify-osd -y
    sudo apt purge dunst -y

    # Graphic application finder, A Graphic replace for dmenu
    echo ====== Install xfce4-appfinder =======
    sudo apt-get install xfce4-appfinder -y

    # Test application finder, A test replace for dmenu
    #echo ====== Install j4-dmenu-desktop =======
    #sudo apt-get install j4-dmenu-desktop -y

    # Text folder size viewer
    sudo apt-get install gt5 -y

    # Network Manager
    echo ====== Install network-manager =======
    sudo apt-get install network-manager -y

    echo ====== Install feh =======
    sudo apt-get install feh -y

    # Screen manager
    echo ====== Install arandr =======
    sudo apt-get install arandr -y 

    # Volume Controller
    echo ====== Install pnmixer =======
    sudo apt-get install pnmixer -y 

    gsettings set org.gnome.desktop.background show-desktop-icons false
}

function link_files()
{
    mkdir -p $HOME/.config/i3/scripts

    ln -sf $DIR/scripts/volume.sh   $HOME/.config/i3/scripts/volume.sh

    ln -sf $DIR/scripts/xrander_script.sh $HOME/.config/i3/scripts/xrander_script.sh
    ln -sf $DIR/scripts/lang.sh $HOME/.config/i3/scripts/lang.sh

    ln -sf $DIR/config $HOME/.config/i3/config

    ln -sf $DIR/i3blocks.conf $HOME/.i3blocks.conf
}

function install()
{
    application_install
    link_files
}

"$@"
