#!/usr/bin/env bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)

source "${DIR}"/09common

summary=""

install_package "C/Cpp" "${DIR}"/../programming-languages/c_cpp
install_package "Python" "${DIR}"/../programming-languages/python
install_package "Node" "${DIR}"/../programming-languages/js_node_npm
install_package "Go" "${DIR}"/../programming-languages/go
install_package "Rust" "${DIR}"/../programming-languages/rust

echo "${summary}"
