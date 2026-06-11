#!/usr/bin/env zsh
_SSH_SYNC_DIR=$(dirname "${(%):-%N}")
_SSH_SYNC_DIR=$(cd -P $_SSH_SYNC_DIR && pwd)

ssh-sync() {
    tusk --file=${_SSH_SYNC_DIR}/tusk_ssh.yml "$@"
}

_ssh-sync() {
    words=("tusk" "--file=${_SSH_SYNC_DIR}/tusk_ssh.yml" "${words[@]:1}")
    (( CURRENT++ ))
    _tusk
}
compdef _ssh-sync ssh-sync
