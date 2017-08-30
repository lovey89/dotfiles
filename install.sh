#!/bin/bash

BACKUP_DIR="$HOME/.dotfiles.backup"
DOTFILES_DIR=$(readlink -f `dirname $0`)

createlink()
{
  HOME_DIR_POSITION="$HOME/$1"
  if [ -h "$HOME_DIR_POSITION" ]; then
    # Check if this link is pointing to the dotfiles directory
    LINK_PATH=$(dirname $(readlink -f "$HOME_DIR_POSITION"))
    if [ "$LINK_PATH" = "$DOTFILES_DIR" ]; then
      echo -e "\033[0;32mSym link for \033[1;34m$1\033[0;32m already exists\033[0m"
      return
    else
      echo -e "\033[0;31mRemoving old symlink \033[1;34m$1 -> $(readlink -f $HOME_DIR_POSITION)\033[0m"
      rm "$HOME_DIR_POSITION"
    fi
  elif [ -e "$HOME_DIR_POSITION" ]; then
    echo -e "\033[0;36mCreating backup of \033[1;34m$1\033[0m"
    mv "$HOME_DIR_POSITION" "$BACKUP_DIR"
  fi
  echo -e "\033[0;33mCreating symlink for \033[1;34m$1\033[0m"
  ln -s "$DOTFILES_DIR/$1" "$HOME_DIR_POSITION"
}

mkdir -p "$BACKUP_DIR"

createlink ".bashrc"
createlink ".bash_aliases"
createlink ".gitconfig"
createlink ".vimrc"
createlink ".Xresources"
createlink ".tmux.conf"

# directories
createlink ".emacs.d"
createlink ".vim"

