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
git_prompt()
{
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  top_level=$(git rev-parse --show-toplevel 2> /dev/null)
  if [ $? -eq 0 ]; then
    project=$(basename "$top_level")
  else
    project=$(echo "$PWD" | sed -rn 's#.*/([^/]+)/.git/?.*#\1#p')
  fi
  git_branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
  echo "($project:$git_branch)"
}
export VIRTUAL_ENV_DISABLE_PROMPT=1
virtualenv_info()
{
  if [[ -n "$VIRTUAL_ENV" ]]; then
    venv="${VIRTUAL_ENV##*/}"
  else
    venv=''
  fi
  [ -n "$venv" ] && echo -e "(\U0001f40d$venv)"
}
k8s_prompt()
{
  if command -v "kubectl" > /dev/null 2>&1; then
    k8s_context=$(kubectl config current-context 2> /dev/null)
    if [ "$?" != 0 ]; then
       k8s_context="NONE"
    fi
  else
    k8s_context=''
  fi
  [ -n "$k8s_context" ] && echo -e "(\u2638 $k8s_context)"
}
PS1='\[\e[0;32m\]\A\[\e[m\] \[\e[0;31m\]$HOSTNAME\[\e[m\]:\[\e[0;36m\]\W\[\e[m\]\[\e[0;33m\]$(git_prompt)\[\e[m\]\[\e[0;35m\]$(virtualenv_info)\[\e[m\]\[\e[0;32m\]$(k8s_prompt)\[\e[m\]\[\e[0;36m\]>\[\e[m\]'
# See for more color codes http://misc.flogisoft.com/bash/tip_colors_and_formatting

# Variables
export VISUAL=vim

export PATH="$PATH":"$DOTFILES_DIR"/scripts:"$DOTFILES_DIR"/configscripts
PATH="$PATH":"$HOME"/.cargo/bin

#export PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
unset -v PROMPT_COMMAND

# Don't save bash commands to history that starts with space and don't save duplicates
export HISTCONTROL="ignorespace:erasedups"

#Use more colors if possible
LINUX_DIST=$(sed -rn 's/^NAME="(.*)"$/\1/p' /etc/os-release)
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
  export TERM='xterm-256color'
elif [ "$LINUX_DIST" == "Ubuntu" ]; then
  # The file /usr/share/terminfo/x/xterm-256color doesn't exists on Ubuntu but the variable still works
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
