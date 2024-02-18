#!/usr/bin/env bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)

source "${DIR}"/09common

summary=""

install_package "keepass" "${DIR}"/../applications/keepass

echo "${summary}"
