#!/bin/bash

set -e 

WORK_DIR=$(dirname "${BASH_SOURCE[0]}")
source $WORK_DIR/utils/addpath.sh

sudo_install()
{
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
    apt-get update
    apt-get install sudo -y
}

user_config()
{
    groupadd -g 1000 $USER
    useradd -g 1000 $USER
    usermod -a -G adm $USER
    echo $USER':a' | chpasswd
    echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
}

create_directories()
{
    echo "Start - Creating directories"
    mkdir "$HOME"
    mkdir "$HOME"/.config
    touch "$HOME"/.profile.path
    touch "$HOME"/.profile.env
    echo "Done - Creating directories"
}

fix_permmision()
{
    chown $USER:$USER --recursive "$HOME"
}


install_verify()
{
    echo "Start - Install Verify"
    # [ "$(stat -c "%u" "$HOME")" != "$(id -u)" ] && (echo "Error the home directory not owned by the user" ; exit 1)
    [ ! -d "$HOME/.config" ] && (echo "ERROR .config wasn't created" ;exit 1)
    # [ ! -d "$HOME/.zsh" ] && (echo "ERROR .zsh wasn't created" ;exit 1)
    echo "Done - Success, verified"
}

run_install() # Main function, this function install everything 
{
    sudo_install
    user_config
    create_directories
    create_profile_path  # Comes from "addpath.sh"
    fix_permmision
}

verify_installation()
{
    # Add here verification functions to your changes
    install_verify
    #################################################
    echo "Installation verification passed"
}

if [ $# -eq 0 ]; then
    grep "^function" "$0"
else
    "$@"
fi
