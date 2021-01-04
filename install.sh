#!/bin/bash

# Packages to install on Fedora: tesseract, ImageMagick, xclip

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

# Generate .minttyrc and .Xresources with specified color scheme
"${DOTFILES_DIR}/templates/create_config_files" mywombat

mkdir -p "$BACKUP_DIR"

createlink ".bashrc"
createlink ".bash_logout"
createlink ".bash_aliases"
createlink ".gitconfig"
createlink ".vimrc"
createlink ".tmux.conf"

# directories
createlink ".emacs.d"
createlink ".vim"

if [ "$OSTYPE" == "cygwin" ]; then
  createlink ".minttyrc"
else
  createlink ".Xresources"
fi

if [ -x "$(command -v dconf)" ]; then
  # If dconf exists, load the settings. This will create (but not set) a profile for gnome terminal
  # If you need to see the settings you run the 'dconf dump' command instead:
  # dconf dump /org/gnome/terminal/legacy/profiles:/
  # or
  # dconf dump /org/gnome/terminal/legacy/profiles:/:3aa6ea65-20c8-456a-a98b-9f3b1c4b583c/
  dconf load /org/gnome/terminal/legacy/profiles:/:3aa6ea65-20c8-456a-a98b-9f3b1c4b583c/ < "${DOTFILES_DIR}/.terminaldconf"
  # dconf read /org/gnome/terminal/legacy/profiles:/list  # Lists available profiles. Add here
  # dfonf write /org/gnome/terminal/legacy/profiles:/list "['3aa6ea65-20c8-456a-a98b-9f3b1c4b583c']"
  # dfonf write /org/gnome/terminal/legacy/profiles:/default "'3aa6ea65-20c8-456a-a98b-9f3b1c4b583c'"
  # Deactivate 2 finger and 3 finger clicks (to right click and middle click). Instead use the dedicated areas
  dconf write /org/gnome/desktop/peripherals/touchpad/click-method "'areas'"
fi

# Create this empty directory because emacs won't do it automatically
mkdir -p "${DOTFILES_DIR}/.emacs.d/autosaves"
