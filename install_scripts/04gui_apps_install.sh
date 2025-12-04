#!/usr/bin/env bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)

source "${DIR}"/09common

summary=""

install_package "firefox" "${DIR}"/../applications/firefox
install_package "keepass" "${DIR}"/../applications/keepass
install_package "Flameshot" "${DIR}"/../applications/flameshot
install_package "Telegram" "${DIR}"/../applications/telegram

echo "${summary}"
