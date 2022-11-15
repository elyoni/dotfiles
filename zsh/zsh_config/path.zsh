
function set_path(){
    local new_path="$1"
    if [ -d $new_path ]; then
        [ $ZSH_DEBUG ] && echo "Add ${new_path} to PATH"
        export PATH=$new_path:$PATH
    fi
}

function main(){
    set_path "/usr/local/go/bin"
    set_path "/usr/local/mvn/bin"
    set_path "$HOME/.local/bin/balena-cli"
}

main
