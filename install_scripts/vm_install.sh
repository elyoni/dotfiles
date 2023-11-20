#!/usr/bin/env bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)

summary=""

function install_package(){
    local package_name="${1}"
    local package_path="${2}"
    local package_install_file="${package_path}"/install

    echo "===== Start: Install ${package_name} ====="
    bash "${package_install_file}" install
    if ! bash "${package_install_file}" verify; then
        summary+="${package_name} verification failed\n"
    fi
    echo "===== End: Install ${package_name} ====="
}

install_package "Ripgrep" "${DIR}"/../applications/ripgrep
install_package "Neovim" "${DIR}"/../neovim
install_package "Fzf" "${DIR}"/../applications/fzf
install_package "Zsh" "${DIR}"/../applications/zsh
install_package "tig" "${DIR}"/../applications/tig
install_package "Ranger" "${DIR}"/../applications/ranger

echo "${summary}"
