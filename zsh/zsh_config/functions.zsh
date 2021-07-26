function ssh.no_verify(){
    #Simple SCP 
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "${@: -1}"
}

function scp.no_verify(){ 
    #Simple SCP 
    scp -r -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${@:1:(($#)-1)} "${@: -1}"
}

function ssh.auto-retry()
{
    if [ "$#" -lt 2 ]; then
        echo "Please provied the password and the connection settings"
        exit
    fi
    false
    while [ $? -ne 0 ]; do
        sshpass -p $1 ssh "${@:2}" || (sleep 1;false)
    done
}

function util.retry-command()
{
    false
    while [ $? -ne 0 ]; do
        "${@}" || (sleep 1;false)
    done
}

