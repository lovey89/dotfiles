alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -la'

alias ..='cd ..'

alias efind='find -L . \( ! -name ".git" -o -prune \) -type f -print0 | xargs -0 grep --color=auto -in'
alias cfind='find -L . \( ! -name ".git" -o -prune \) -type f -print0 | xargs -0 grep -C 10 --color=auto -in'

# This will make sudo available for aliases as well
alias sudo='sudo '
