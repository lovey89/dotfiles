#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return



BASH_ALIASES=".bash_aliases"

#Load aliases
if [ -f "$BASH_ALIASES" ]; then
    . "$BASH_ALIASES"
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
VISUAL=vim

#Use more colors if possible
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi
