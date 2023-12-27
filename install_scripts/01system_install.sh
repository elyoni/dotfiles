#!/usr/bin/env bash

source 09common

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)

summary=""

install_package "Regolith3" "${DIR}"/../system/regolith/
install_package "Fonts" "${DIR}"/../system/fonts/
install_package "Bluetooth" "${DIR}"/../system/bluetooth/
install_package "Network" "${DIR}"/../system/network/


echo "${summary}"
