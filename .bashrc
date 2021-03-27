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
# R:   Show control characters but still handle colors correctly
# S:   Don't wrap long lines (NOT USED!)
# #.5: Horizontally scroll half page
# M:   Long prompt
# i:   Case insensitive search unless there are upper chase characters in search pattern
# J:   Status column used by searches and by W option (NOT USED!)
# j.5: When jumping to a target (e.g. when searching). Place it in middle of screen
# W:   Highlight first new line after forward movement larger than 1 line
# z-4: When scrolling a full page, scroll so there are 4 lines left from previous page
export LESS="-R#.5Mij.5Wz-4"

if [ "$OSTYPE" != "cygwin" ]; then
  # It looks like cygwin handles this variable poorly
  # Close less automatically if file fits on one screen
  LESS="${LESS}F"
fi

if [ -x "$(command -v highlight)" -o -x "$(command -v source-highlight)" ]; then
  # If highlight or source-highlight is available we can use it to syntax highlight in less
  export LESSOPEN="||- $DOTFILES_DIR/scripts/my-src-hilite-lesspipe.sh %s"
fi

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
