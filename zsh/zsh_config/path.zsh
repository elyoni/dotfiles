

function set_path(){
    local new_path="$1"
    if [ -d $new_path ]; then
        export PATH=$new_path:$PATH
    fi
}

function main(){
    set_path "/usr/local/go/bin"
    set_path "/usr/local/mvn/bin"
}


main
