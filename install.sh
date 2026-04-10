#!/bin/bash
set -e

LOCAL_BIN="$HOME/.local/bin"
CFG="$HOME/.config"

mkdir -p "$CFG" 2> /dev/null
mkdir -p "$LOCAL_BIN" 2> /dev/null

CUR=$(pwd)
curl -Ls https://raw.githubusercontent.com/owpk/dots-misc/refs/heads/main/install-deps.sh | bash -s -- "$CUR/deps"

function prepareBackups() {
   echo "Creating backup..."
   BACKUP_DIR="$HOME/dotfiles-backups"
   mkdir -p "$BACKUP_DIR/.config" 2> /dev/null

   for filename in $(ls "$CUR/.config"); do
      echo "Processing backup for file: $filename"
      echo "MV: $CFG/$filename -> $BACKUP_DIR/.config"
      mv "$CFG/$filename" "$BACKUP_DIR/.config" 2> /dev/null || true
   done

   mv "$HOME/.zshenv" "$BACKUP_DIR/" 2> /dev/null || true
   mv "$HOME/.tmux.conf" "$BACKUP_DIR/" 2> /dev/null || true
}

prepareBackups

stow --adopt -vt "$CFG" .config
stow --adopt -vt "$LOCAL_BIN" scripts

ln -nsf "$CUR/.zshenv" "$HOME/"
ln -nsf "$CUR/.tmux.conf" "$HOME/"

if git show-ref --verify --quiet "refs/heads/$USER"; then
   echo "Branch '$USER' already exists, switching to it"
   git checkout "$USER"
else
   git checkout -b "$USER"
fi

sudo chsh -s "$(which zsh)" "$USER"

curl -Ls https://github.com/owpk/gigachat-grpc-client/raw/main/install.sh | bash
