#!/usr/bin/env bash
function ssh.no_verify(){
    local user_host="$1"
    local command="${@:2}"
    #Simple SSH
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$user_host" "$command"
}

function scp.no_verify(){ 
    #Simple SCP 
    local user_host="$1"
    local command="${@:2}"
    scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$user_host" "$command"
}

function ssh.auto-retry()
{
    if [[ "$1" == "-h"
    if [ "$#" -lt 2 ]; then
        echo "Please provied the password and the connection settings"
        exit
    fi
    false
    while [ $? -ne 0 ]; do
        echo sshpass -p $1 ssh "${@:2}" || (sleep 1;false)
    done
}

function util.retry-command()
{
    false
    while [ $? -ne 0 ]; do
        "${@}" || (sleep 1;false)
    done
}

