#!/bin/bash

LOCAL_BIN=$HOME/.local/bin
CFG=$HOME/.config

mkdir $CFG 4> /dev/null
mkdir $LOCAL_BIN 2> /dev/null

CUR=$(pwd)
curl -Ls https://raw.githubusercontent.com/owpk/dots-misc/refs/heads/main/install-deps.sh | bash -s -- $CUR/deps

function prepareBackups() {
   echo "Creating backup..."
   BACKUP_DIR="$HOME/dotfiles-backups"
   mkdir -p $BACKUP_DIR/.config 2> /dev/null

   TR=$(ls $CUR/.config)

   for filename in $TR; do
      echo "Processing backup for file: $filename"
      echo "MV: $CFG/$filename -> $BACKUP_DIR/.config"
      mv $CFG/$filename $BACKUP_DIR/.config
   done

   mv $HOME/.zshenv $BACKUP_DIR/
   mv $HOME/.tmux.conf $BACKUP_DIR/
}

stow --adopt -vt $CFG .config
stow --adopt -vt $LOCAL_BIN scripts 

ln -nsf $CUR/.zshenv $HOME/
ln -nsf $CUR/.tmux.conf $HOME/

git checkout -b $USER

sudo chsh -s $(which zsh) $USER

curl -Ls https://github.com/owpk/gigachat-grpc-client/raw/main/install.sh | bash
