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

function set_nvm_default_path(){
    # Smart NVM path detection without loading NVM
    # Optimized: uses zsh builtins instead of cat/ls/sort/tail subprocesses
    local nvm_dir="${NVM_DIR:-$HOME/.config/nvm}"
    
    [[ -d "$nvm_dir" ]] || return
    
    # Try to find default alias first (using zsh $(<file) instead of cat)
    if [[ -f "$nvm_dir/alias/default" ]]; then
        local default_version=$(<"$nvm_dir/alias/default")
        local node_path="$nvm_dir/versions/node/$default_version/bin"
        if [[ -d "$node_path" ]]; then
            set_path "$node_path"
            return
        fi
    fi
    
    # Fallback: find the latest installed version using zsh glob qualifiers
    # (On) = reverse name sort, [1] = first element = latest version
    local versions=("$nvm_dir/versions/node"/*(NOn:t))
    if (( ${#versions} > 0 )); then
        local node_path="$nvm_dir/versions/node/${versions[1]}/bin"
        set_path "$node_path"
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
    set_path "${HOME}/.platformio/penv/bin"
    set_path "${HOME}/Apps/zig"
    set_path "${HOME}/.local/share/flatpak/exports/share"
    
    # Smart NVM path detection
    set_nvm_default_path
}

set_other_path
main
