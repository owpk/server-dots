#!/bin/sh

echo "please make sure you have install dependencies: $(cat ./deps)"

mkdir $HOME/.config
mkdir $HOME/.local/bin
CFG=$HOME/.config
CUR=$(pwd)

stow --adopt -vt $CUR/.config $CFG

ln -s $CUR/.zshenv $HOME/
ln -s $CUR/.tmux.conf $HOME/
cp scripts/* $HOME/.local/bin/
