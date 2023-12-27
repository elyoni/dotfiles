#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

function audio(){
    echo ====== Install audio application =======
    sudo apt-get install pulseaudio -y # To run the settings just run 'pavucontrol'

    # GUI application to control the pulseaudio
    sudo apt-get install pavucontrol -y # To run the settings just run 'pavucontrol'

    # Terminal application to control the pulseaudio
    sudo pip3 install pulsemixer -y
}

function bluetooth(){
    echo ====== Install bluetooth application =======
    # Give GUI
    sudo apt-get install blueman -y
}

function application_finder(){
    echo ====== Install application_finder =======
    # Not Using - xfce4 - application finder. Stopped using the app because I have found rofi more readable
    # sudo apt-get install xfce4-appfinder -y
    # sudo apt-get install xfce4-panel -y
    sudo apt-get install gnome-icon-theme -y

    # Rofi - My main application finder
    sudo apt-get install rofi -y

    # Test application finder, A test replace for dmenu
    #echo ====== Install j4-dmenu-desktop =======
    #sudo apt-get install j4-dmenu-desktop -y
    
}

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
    application_finder

    # Text folder size viewer
    sudo apt-get install gt5 -y

    audio
    blueman

    # Network Manager
    echo ====== Install network-manager =======
    sudo apt-get install network-manager -y

    echo ====== Install feh =======
    sudo apt-get install feh -y

    # Screen manager
    echo ====== Install arandr =======
    sudo apt-get install arandr -y 
    sudo apt-get install autorandr -y

    # Volume Controller
    echo ====== Install pnmixer =======
    #sudo apt-get install pnmixer -y 
    sudo apt-get install pasystray -y 
    sudo pip3 install pulsemixer 

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
