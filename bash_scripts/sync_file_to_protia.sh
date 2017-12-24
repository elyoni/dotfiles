#!/bin/bash
ip_file_path="$HOME/.ipPortia.txt"
ip=$(<$ip_file_path)
echo $PWD
if [[ $1 == *"/site-packages"*  ]]; then
    path="/usr/lib/python3.4/site-packages"
    path="$path${1#*site-packages}"
    extension=${path##*.}
    file_name=${path##*/}

    # Check if pyc is exists
    sshpass -f /home/yehonatan.e/.passPortia.txt ssh root@$ip "test -e ${path%.*}.pyc"
    if [ $? -eq 0 ]; then
        # Found pyc file, Now will erase it
        sshpass -f /home/yehonatan.e/.passPortia.txt ssh root@$ip "rm ${path%.*}.pyc"
    fi
    sshpass -f /home/yehonatan.e/.passPortia.txt scp -o ConnectTimeout=5 -o StrictHostKeyChecking=no $1 root@$ip:$path
    
    if [ $? -eq 0 ]; then
        echo "*****************************************" 
        echo "    DONE copy $file_name to server " 
        echo "*****************************************" 
    else
        echo "******************************************" 
        echo "  ERORR copy $file_name to server         " 
        echo "******************************************" 
    fi
fi
