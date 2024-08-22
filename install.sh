#!/bin/sh

mkdir $HOME/.config
mkdir $HOME/.local/bin
CFG=$HOME/.config
CUR=$(pwd)

ln -s $CUR/.config/zsh $CFG/
ln -s $CUR/.config/nvim $CFG/
ln -s $CUR/.config/ranger $CFG/
ln -s $CUR/.zshenv $HOME/
ln -s $CUR/.tmux.conf $HOME/
cp scripts/* $HOME/.local/bin/

git checkout -b $(cat /proc/sys/kernel/hostname | awk '{print tolower($0)}')
