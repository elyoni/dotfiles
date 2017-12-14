#!/bin/bash

ip_file_path="$HOME/.ipPortia.txt"
ip=$(<$ip_file_path)
pmanger_path=/usr/lib/python3.4/site-packages/management/pmanager
sshpass -f /home/yehonatan.e/.passPortia.txt ssh root@$ip "killall python"

sshpass -f /home/yehonatan.e/.passPortia.txt ssh root@$ip "test -e $pmanger_path.pyc"
if [ $? -eq 0 ]; then
    echo Found pmanager.pyc
    sshpass -f /home/yehonatan.e/.passPortia.txt ssh root@$ip "python $pmanger_path.pyc &"
else
    echo Found pmanager.py
    sshpass -f /home/yehonatan.e/.passPortia.txt ssh root@$ip "python $pmanger_path.py &"
fi

echo "**************************" 
echo "  Restarted pmanager      " 
echo "**************************" 
