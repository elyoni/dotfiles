#!/usr/bin/env bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)

source "${DIR}"/09common

summary=""

install_package "Regolith3" "${DIR}"/../system/regolith/
install_package "Fonts" "${DIR}"/../system/fonts/
install_package "Bluetooth" "${DIR}"/../system/bluetooth/
install_package "Network" "${DIR}"/../system/network/
install_package "SSH" "${DIR}"/../system/ssh/
install_package "AppImage" "${DIR}"/../system/appimage
install_package "Flatpak" "${DIR}"/../system/flatpak
install_package "Bluetui" "${DIR}"/../system/tui_application/bluetui
install_package "Pulsemixer" "${DIR}"/../system/tui_application/pulsemixer


echo "${summary}"
