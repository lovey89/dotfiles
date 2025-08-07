#!/usr/bin/env bash

# Packages to install on Fedora: tesseract, ImageMagick, xclip

BACKUP_DIR="$HOME/.dotfiles.backup"
DOTFILES_DIR=$(readlink -f `dirname $0`)

createlink()
{
  ORIG_PATH="$1"
  PATH_RELATIVE_HOME="$2"
  if [ -n "$PATH_RELATIVE_HOME" ]; then
    mkdir -p $(dirname "$HOME/$PATH_RELATIVE_HOME")
    HOME_DIR_POSITION="$HOME/$PATH_RELATIVE_HOME"
  else
    HOME_DIR_POSITION="$HOME/$ORIG_PATH"
  fi

  if [ -h "$HOME_DIR_POSITION" ]; then
    # Check if this link is pointing to the dotfiles directory
    LINK_PATH=$(dirname $(readlink -f "$HOME_DIR_POSITION"))

    if [ -z "$PATH_RELATIVE_HOME" ] && [ "$LINK_PATH" = "$DOTFILES_DIR" ]; then
      echo -e "\033[0;32mSym link for \033[1;34m$ORIG_PATH\033[0;32m already exists\033[0m"
      return
    elif [ "$LINK_PATH" = "$DOTFILES_DIR/$(dirname $ORIG_PATH)" ]; then
      echo -e "\033[0;32mSym link for \033[1;34m$ORIG_PATH\033[0;32m already exists\033[0m"
      return
    else
      echo -e "\033[0;31mRemoving old symlink \033[1;34m$ORIG_PATH -> $(readlink -f $HOME_DIR_POSITION)\033[0m"
      rm "$HOME_DIR_POSITION"
    fi
  elif [ -e "$HOME_DIR_POSITION" ]; then
    echo -e "\033[0;36mCreating backup of \033[1;34m$ORIG_PATH\033[0m"
    mv "$HOME_DIR_POSITION" "$BACKUP_DIR"
  fi
  echo -e "\033[0;33mCreating symlink for \033[1;34m$ORIG_PATH\033[0m"
  ln -s "$DOTFILES_DIR/$ORIG_PATH" "$HOME_DIR_POSITION"
}

createcopy()
{
  ORIG_PATH="$1"
  if [[ "${ORIG_PATH}" != /* ]]; then
    ORIG_PATH="$DOTFILES_DIR/$ORIG_PATH"
  fi
  COPY_PATH="$2"

  if [ -d "$ORIG_PATH" ]; then
    for file in "$ORIG_PATH"/*; do
      if [ -z "$COPY_PATH" ]; then
        createcopy "$file" "$(basename "$file")"
      else
        createcopy "$file" "${COPY_PATH}/$(basename "$file")"
      fi
    done
    return
  fi

  if [ -z ${COPY_PATH} ]; then
    COPY_PATH="$HOME/$ORIG_PATH"
  elif [[ ${COPY_PATH} != /* ]]; then
    COPY_PATH="$HOME/$COPY_PATH"
  fi

  mkdir -p $(dirname "$COPY_PATH")

  if [ ! -f "$COPY_PATH" ]; then
    echo -e "\033[0;33mCopying \033[1;34m$ORIG_PATH\033[0;33m to \033[1;34m$COPY_PATH\033[0m"
    cp "$ORIG_PATH" "$COPY_PATH"
  elif diff -q "$ORIG_PATH" "$COPY_PATH" > /dev/null ; then
    echo -e "\033[0;32mFile \033[1;34m$ORIG_PATH\033[0;32m already exists at \033[1;34m$COPY_PATH\033[0m"
  else
    echo -e "\033[0;31mFile with wrong content exists at \033[1;34m$COPY_PATH\033[0;31m. Nothing is copied, remove it manually\033[0m" >&2
  fi
}

# Generate .minttyrc, .wezterm and .Xresources with specified color scheme
"${DOTFILES_DIR}/templates/create_config_files" mywombat

mkdir -p "$BACKUP_DIR"

createlink ".bashrc"
createlink ".bash_logout"
createlink ".bash_aliases"
createlink ".gitconfig"
createlink ".vimrc"
createlink ".tmux.conf"
createlink ".tmux-floating.conf"
createlink ".wezterm.lua"
createlink ".pg_format"

# directories
createlink ".emacs.d"
createlink ".vim"
createlink ".config/wezterm" ".config/wezterm"
createlink ".gnupg/gpg-agent.conf" ".gnupg/gpg-agent.conf"

if grep -q "microsoft" /proc/sys/kernel/osrelease; then
  # WSL
  #sudo apt install --no-install-recommends wslu
  WINHOME=$(wslpath "$(wslvar USERPROFILE)")
  # Looks like as if you can't create a link from windows to wsl so we copy the
  # files instead
  mkdir -p "$WINHOME/.config/wezterm/colors"
  createcopy ".wezterm.lua" "$WINHOME/.config/wezterm/wezterm.lua"
  createcopy ".config/wezterm/colors" "$WINHOME/.config/wezterm/colors"
  # Find path to 1password command on windows
  # In powershell install 1passowrd-cli
  #winget install 1password-cli
  #powershell.exe -c "Get-Command op | Select-Object -ExpandProperty Source" | tr '\\' '/' | sed -r 's#^C:#/mnt/c#'

  #VS_CODE_CONFIG_DIR_PATH=".vscode-server/data/User"
  VS_CODE_CONFIG_DIR_PATH="$WINHOME/AppData/Roaming/Code/User/"
  VS_CODE_KEY_BINDING_FILE="windows-keybindings.json"
  VS_CODE_FILES_COPY="true"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # MacOS
  createlink ".bash_profile"
  VS_CODE_CONFIG_DIR_PATH="Library/Application Support/Code/User"
  VS_CODE_KEY_BINDING_FILE="macos-keybindings.json"
elif [ "$OSTYPE" == "cygwin" ]; then
  createlink ".minttyrc"
else
  createlink ".Xresources"
  VS_CODE_CONFIG_DIR_PATH=".config/Code/User"
  VS_CODE_KEY_BINDING_FILE="linux-keybindings.json"
fi

if [ ! -z ${VS_CODE_CONFIG_DIR_PATH+x} ] && [ -d "${HOME}/${VS_CODE_CONFIG_DIR_PATH}" ]; then
  if [ "$VS_CODE_FILES_COPY" == "true" ]; then
    createcopy "vscode/config/settings.json" "${VS_CODE_CONFIG_DIR_PATH}/settings.json"
    createcopy "vscode/config/${VS_CODE_KEY_BINDING_FILE}" "${VS_CODE_CONFIG_DIR_PATH}/keybindings.json"
  else
    createlink "vscode/config/settings.json" "${VS_CODE_CONFIG_DIR_PATH}/settings.json"
    createlink "vscode/config/${VS_CODE_KEY_BINDING_FILE}" "${VS_CODE_CONFIG_DIR_PATH}/keybindings.json"
  fi
else
  echo -e "\033[0;31mVS Code config folder was not found\033[0m" >&2
fi

if [ -x "$(command -v dconf)" ]; then
  # If dconf exists, load the settings. This will create (but not set) a profile for gnome terminal
  # If you need to see the settings you run the 'dconf dump' command instead:
  # dconf dump /org/gnome/terminal/legacy/profiles:/
  # or
  # dconf dump /org/gnome/terminal/legacy/profiles:/:3aa6ea65-20c8-456a-a98b-9f3b1c4b583c/
  dconf load /org/gnome/terminal/legacy/profiles:/:3aa6ea65-20c8-456a-a98b-9f3b1c4b583c/ < "${DOTFILES_DIR}/.terminaldconf"
  # dconf read /org/gnome/terminal/legacy/profiles:/list  # Lists available profiles. Add here
  dconf write /org/gnome/terminal/legacy/profiles:/list "['3aa6ea65-20c8-456a-a98b-9f3b1c4b583c']"
  dconf write /org/gnome/terminal/legacy/profiles:/default "'3aa6ea65-20c8-456a-a98b-9f3b1c4b583c'"
  # Deactivate 2 finger and 3 finger clicks (to right click and middle click). Instead use the dedicated areas
  dconf write /org/gnome/desktop/peripherals/touchpad/click-method "'areas'"
  # Enable tap-to-click on touchpad
  dconf write /org/gnome/desktop/peripherals/touchpad/tap-to-click "true"
  # dconf dump /org/gnome/desktop/peripherals/touchpad/
fi

if [ -x "$(command -v gsettings)" ]; then
  # Defaults
  # gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left ['<Super>Page_Up', '<Super><Alt>Left', '<Control><Alt>Left']
  # gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>Page_Down', '<Super><Alt>Right', '<Control><Alt>Right']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>Page_Up', '<Super><Alt>Left']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>Page_Down', '<Super><Alt>Right']"
fi

# Create this empty directory because emacs won't do it automatically
mkdir -p "${DOTFILES_DIR}/.emacs.d/autosaves"

if [ -d "/opt/homebrew/share/highlight/themes" ]; then
  if [ ! -f "/opt/homebrew/share/highlight/themes/mywombat2.theme" ]; then
    sudo ln -s "${DOTFILES_DIR}/resources/mywombat2.theme" "/opt/homebrew/share/highlight/themes/mywombat2.theme"
  fi
elif [ -d "/usr/share/highlight/themes" ]; then
  if [ ! -f "/usr/share/highlight/themes/mywombat2.theme" ]; then
    sudo ln -s "${DOTFILES_DIR}/resources/mywombat2.theme" "/usr/share/highlight/themes/mywombat2.theme"
  fi
else
  echo -e "\033[0;31mhighlight command isn't installed and the theme could not be installed\033[0m" >&2
fi
