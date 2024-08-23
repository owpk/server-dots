#!/bin/sh

echo "please make sure you have install dependencies: $(cat ./deps)"

LOCAL_BIN=$HOME/.local/bin
CFG=$HOME/.config

mkdir $CFG 2> /dev/null
mkdir $LOCAL_BIN 2> /dev/null

CUR=$(pwd)

stow --adopt -vt $CFG .config
stow --adopt -vt $LOCAL_BIN scripts 

ln -nsf $CUR/.zshenv $HOME/
ln -nsf $CUR/.tmux.conf $HOME/

