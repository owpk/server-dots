#!/bin/bash

echo "please make sure you have install dependencies: $(cat ./deps)"

LOCAL_BIN=$HOME/.local/bin
CFG=$HOME/.config

mkdir $CFG 4> /dev/null
mkdir $LOCAL_BIN 2> /dev/null

CUR=$(pwd)

stow --adopt -vt $CFG .config
stow --adopt -vt $LOCAL_BIN scripts 

ln -nsf $CUR/.zshenv $HOME/
ln -nsf $CUR/.tmux.conf $HOME/

git checkout -b $USER

read -p "Install gigachat? (Y/n): " INSTALL_GIGA

if [ "$INSTALL_GIGA" == "Y" ]; then
    sh <(curl -L https://github.com/owpk/gigachat-grpc-client/raw/main/install.sh)
fi
