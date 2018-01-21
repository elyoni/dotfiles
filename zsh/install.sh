#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)


ln -sf $DIR/.zshrc $HOME/.zshrc
