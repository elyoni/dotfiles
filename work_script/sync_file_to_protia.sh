#!/bin/bash
if [[ $1 == "-i"  ]]; then
# Create the files:
##.ipPortia.txt,.passPortia.txt
    echo 'a' > "$HOME/.passPortia.txt"
    echo '10.90.1.1' > "$HOME/.ipPortia.txt"
    echo "I Have Been crated your file"
    echo "$HOME/.ipPortia.txt"
else
    ip_file_path="$HOME/.ipPortia.txt"
    password_file_path="$HOME/.passPortia.txt"
    ip=$(<$ip_file_path)
    if [[ $1 == *"/site-packages"*  ]]; then

        python3.4 -m compileall $1

        if [ $? -eq 0 ]; then
            file_name=${1##*/}
            file_name=${file_name%.*}

            path_to="/usr/lib/python3.4/site-packages"
            path_to="$path_to${1#*site-packages}"
            path_to=${path_to%.*}.pyc
            path_from=${1%/*}/__pycache__/$file_name.cpython-34.pyc
            #path_from=${1%/*}/$file_name.pyc

            echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            echo PC Path: $path_from
            echo Portia Path: $path_to
            echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

            sshpass -f $password_file_path scp -r -o ConnectTimeout=5 -o StrictHostKeyChecking=no $path_from root@$ip:$path_to

            if [ $? -eq 0 ]; then
                echo "*****************************************" 
                echo "    1. DONE copy $file_name to server " 
                echo "*****************************************" 
            else
                # Create the path
                sshpass -f $password_file_path ssh root@$ip -o ConnectTimeout=1 -o StrictHostKeyChecking=no -o ConnectionAttempts=1 mkdir -p  ${path_to%/*}/
                if [ $? -eq 0 ]; then
                    sshpass -f $password_file_path scp -r -o ConnectTimeout=1 -o StrictHostKeyChecking=no -o ConnectionAttempts=1 $path_from root@$ip:$path_to
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
            rm -R ${1%/*}/__pycache__/

        else
            echo "******************************************" 
            echo "  ERORR Compiling the file $file_name"
            echo "******************************************" 
        fi
        #rm $path_from
    fi
fi
