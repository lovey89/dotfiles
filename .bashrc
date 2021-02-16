#!/bin/bash
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

MY_BASH_ALIASES="$HOME/.bash_aliases"
MY_LOCAL_SETTINGS="$HOME/.bash_local"
DOTFILES_DIR=$(dirname `readlink -f "$HOME/.bashrc"`)

shopt -s histappend

# Load aliases
if [ -f "$MY_BASH_ALIASES" ]; then
  . "$MY_BASH_ALIASES"
fi

# Prompt
git_prompt ()
{
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  git_branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
  echo "($git_branch)"
}
PS1='\[\e[0;32m\]\A\[\e[m\] \[\e[0;31m\]$HOSTNAME\[\e[m\]:\[\e[0;36m\]\W\[\e[m\]\[\e[0;33m\]$(git_prompt)\[\e[m\]\[\e[0;36m\]>\[\e[m\]'
# See for more color codes http://misc.flogisoft.com/bash/tip_colors_and_formatting

# Variables
export VISUAL=vim
export PATH="$PATH":"$DOTFILES_DIR"/scripts:"$DOTFILES_DIR"/configscripts
#export PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
unset -v PROMPT_COMMAND
# Options used by the 'less' command
export LESS="-RS#.5MiJj.5Wz-4"
if [ -x "$(command -v source-highlight)" ]; then
  # If source-highlight is available we can use it to syntax highlight in less
  export LESSOPEN="||- $DOTFILES_DIR/scripts/my-src-hilite-lesspipe.sh %s"
fi

# Don't save bash commands to history that starts with space and don't save duplicates
export HISTCONTROL="ignorespace:erasedups"

if [ "$OSTYPE" != "cygwin" ]; then
  # It looks like cygwin handles this variable poorly
  LESS="${LESS}F"
fi

#Use more colors if possible
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
  export TERM='xterm-256color'
elif [ "$OSTYPE" == "cygwin" ]; then
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi

# Load local settings
if [ -f "$MY_LOCAL_SETTINGS" ]; then
  . "$MY_LOCAL_SETTINGS"
fi
