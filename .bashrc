#!/bin/bash
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

DOTFILES_DIR=$(dirname `readlink -f "$HOME/.bashrc"`)
MY_BASH_ALIASES="$HOME/.bash_aliases"
MY_LOCAL_SETTINGS="$HOME/.bash_local"
MY_LESS_SETTINGS="$DOTFILES_DIR/.bash_less"

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
export VIRTUAL_ENV_DISABLE_PROMPT=1
virtualenv_info()
{
  if [[ -n "$VIRTUAL_ENV" ]]; then
    venv="${VIRTUAL_ENV##*/}"
  else
    venv=''
  fi
  [ -n "$venv" ] && echo "(venv:$venv)"
}
PS1='\[\e[0;32m\]\A\[\e[m\] \[\e[0;31m\]$HOSTNAME\[\e[m\]:\[\e[0;36m\]\W\[\e[m\]\[\e[0;33m\]$(git_prompt)\[\e[m\]\[\e[0;35m\]$(virtualenv_info)\[\e[m\]\[\e[0;36m\]>\[\e[m\]'
# See for more color codes http://misc.flogisoft.com/bash/tip_colors_and_formatting

# Variables
export VISUAL=vim
export PATH="$PATH":"$DOTFILES_DIR"/scripts:"$DOTFILES_DIR"/configscripts
#export PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
unset -v PROMPT_COMMAND

# Don't save bash commands to history that starts with space and don't save duplicates
export HISTCONTROL="ignorespace:erasedups"

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

# Load less settings
if [ -f "$MY_LESS_SETTINGS" ]; then
  . "$MY_LESS_SETTINGS"
fi
