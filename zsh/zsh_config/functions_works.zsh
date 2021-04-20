function sip
{
    export PORTIA_IP=$1
    export PORTIA_PORT=80
}

function rt(){
    # Run test
    # Will popup a message when finished
    python3.4 $@ ; ssh -p 2222 -i ~/.ssh/yoni_laptop yoni@localhost 'DISPLAY=:0 notify-send -u critical Test: "test has finished"'
}

zle     -N   fzf-test
_shell_complete(){
    local output 
    #output=$(_fzf_complete '+m' "$@" < <(command ls))
    output=$(_shell_complete_loop | fzf)
    # need to remove after ##
    output=$( echo $output | sed -e "s@##.*@@g" | sed -r 's/^\s+$//' )
    echo $output"yoni"
}

_shell_complete_loop(){
    local file_list y 
    for x in $(find $SHELL_DIR -type f -name "*.py"); do
        file_list=$( echo $x | sed "s#$SHELL_DIR/##g" )
        #base=$(echo $x | sed -e 's/\(.*\)\///' -e 's/.py//')
        y=$(sed -n '2p' $x | grep "##")
        #echo $file_list
        echo -e $file_list "\t" $y
    done
}


function fzf-test(){
    zle reset-prompt
    #LBUFFER="${LBUFFER}$(_shell_complete)"
    LBUFFER="p $(_shell_complete)"
    return 0
}

bindkey '^W' fzf-test
