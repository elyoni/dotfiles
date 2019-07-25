#!/bin/bash
password="a"   #"$HOME/.passPortia.txt"
source $HOME/projects/tools/configurations


function upload_file(){
    path_from=$1
    path_to=$2
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo PC Path: $path_from
    echo Portia Path: $path_to
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

    #sshpass -f $password_file_path scp -r -o ConnectTimeout=5 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $path_from root@$ip:$path_to
    sshpass -p $password scp -r -o ConnectTimeout=60 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $path_from root@$PORTIA_IP:$path_to
    if [ $? -eq 0 ]; then
        echo "*****************************************" 
        echo "    1. DONE copy $file_name to server" 
        echo "*****************************************" 
        reset_pmanager
    else
        # Create the path
        sshpass -p $password scp -r -o ConnectTimeout=60 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $path_from root@$PORTIA_IP:$path_to
        if [ $? -eq 0 ]; then
            sshpass -p $password scp -r -o ConnectTimeout=60 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $path_from root@$PORTIA_IP:$path_to
            echo "*****************************************" 
            echo "      File path has created " 
            echo "    2. DONE copy $file_name to server " 
            echo "*****************************************" 
        else
            echo "******************************************" 
            echo "  ERORR copy $file_name to server         " 
            echo "******************************************" 
        fi
    fi
}

function reset_pmanager(){
    read -p "Do you want to reset the pmanager [Y/n]? " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        sshpass -p 'a' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$PORTIA_IP 'killall python'
        echo "# Reset Pmanager"
    fi
}

function python_upload(){
    python3.4 -m compileall $1

    if [ $? -eq 0 ]; then
        file_name=${1##*/}
        file_name=${file_name%.*}

        path_to="/usr/lib/python3.4/site-packages"
        path_to="$path_to${1#*site-packages}"
        path_to=${path_to%.*}.pyc
        path_from=${1%/*}/__pycache__/$file_name.cpython-34.pyc
        #path_from=${1%/*}/$file_name.pyc
        echo $path_from $path_to
        upload_file $path_from $path_to

        rm -R ${1%/*}/__pycache__/

    else
        echo "******************************************" 
        echo "  ERORR Compiling the file $file_name"
        echo "******************************************" 
    fi
}

function core_upload(){
    core_dir=$(~/projects/sources/apps/core/)
    proto_dir=$(~/projects/proto/)
    make clean -C ${core_dir}
    make -C ${core_dir} PLATFORM=sama5d2 PROTO_PATH=${proto_dir}

    path_from=~/projects/sources/apps/core/bin/Main
    upload_file $path_from $path_to
}
if [[ $1 == *"/core/"*  ]]; then
    core_upload
elif [[ $1 == *"/site-packages/"*  ]]; then
    python_upload $1
fi 
