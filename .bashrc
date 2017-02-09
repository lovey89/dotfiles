#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

MY_BASH_ALIASES="$HOME/.bash_aliases"

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

# Variables
export VISUAL=vim
export PATH="$PATH":"$HOME"/dotfiles/scripts
#export PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
unset -v PROMPT_COMMAND
# Options used by the 'less' command
export LESS="-RS#3Mgi"

#Use more colors if possible
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi
