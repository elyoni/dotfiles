function set_other_path(){
    local gopath="$HOME/.local/go"
    if [[ "${gopath}" != "*${GOPATH}*" ]]; then
        export GOPATH="${gopath}"
    fi

    local pyenv="$HOME/.pyenv"
    if [[ "${pyenv}" != "*${PYENV_ROOT}*" ]]; then
        export PYENV_ROOT="${pyenv}"
    fi
}
function set_path(){
    local new_path="$1"
    if [ -d $new_path ]; then
        [ $ZSH_DEBUG ] && echo "Add ${new_path} to PATH"
        export PATH=$new_path:$PATH
    fi
}

function main(){
    set_path "/usr/local/go/bin"
    set_path "${GOPATH}/bin"
    set_path "/usr/local/mvn/bin"
    set_path "${HOME}/.local/bin/balena-cli"
    set_path "${HOME}/.local/bin"
    set_path "${PYENV_ROOT}/bin"
    set_path "${HOME}/.cargo/bin"
}

set_other_path
main
