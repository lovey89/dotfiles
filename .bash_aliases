#!/bin/bash

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -la'

alias ..='cd ..'
alias cd..="cd .."

alias efind='find -L . \( ! -name ".git" -a ! -name ".idea" -o -prune \) -type f -print0 | xargs -0 grep --color=auto -in'
alias cfind='find -L . \( ! -name ".git" -a ! -name ".idea" -o -prune \) -type f -print0 | xargs -0 grep -C 10 --color=auto -in'

# This will make sudo available for aliases as well
alias sudo='sudo '

# If you're behind a proxy and need to authenticate (better than saving your password in a file)
alias proxyauth='curl -sU "$USER" http://www.google.se > /dev/null'

# Functions

unzipbase64()
{
  echo "$1" | base64 -d | gunzip
}

ffind()
{
  find . -iname "*$1*"
}

afind() # Needs more testing!
{
  OPTIND=1 # Needed to get getopts to work

  FILE_ENDING=""
  FILE_PATH="\( ! -name .git -a ! -name .idea -o -prune \)"

  while getopts ":i:t:" opt; do
    case $opt in
      i)
        FILE_PATH="\( ! -name .git -a ! -name .idea -a ! -path \*/$OPTARG -o -prune \)"
        ;;
      t)
        FILE_ENDING="-iname *.$OPTARG"
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
      :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
  done

  shift $((OPTIND-1))

  # In order to treat the glob expression (*) correctly use the eval command
  eval "find -L . $FILE_PATH $FILE_ENDING -type f -print0 | xargs -0 grep --color=auto -in \"$1\""
  #echo $FILE_PATH
  #echo $FILE_ENDING
  #echo $1
  #echo "find -L . $FILE_PATH $FILE_ENDING -type f -print0 | xargs -0 grep --color=auto -in $1"
}

sha1sumdir()
{
  for var in "$@"; do
    if [ -d "$var" ]; then
      HASH=$(find "$var" -xtype f -print0 | xargs -0 sha1sum | cut -b-40 | sort | sha1sum | cut -b-40)
      echo "DIR   $HASH  $var"
    else
      HASH=$(sha1sum "$var")
      echo "FILE  $HASH"
    fi
  done
}

charcount()
{
  wc -m <(echo -nE "$1") | cut --delimiter=' ' -f1
}

pathreplace()
{
  find . \( ! -name ".git" -o -prune \) -type f -exec sed -b -i "s/$1/$2/g" {} \;
}

if [ "$OSTYPE" == "cygwin" ]; then
  # Aliases for cygwin (Windows)
  alias winkill='taskill /PID'
  alias fwinkill='taskill /F /PID'
  alias winkillall='taskkill /IM'
  alias fwinkillall='taskkill /F /IM'
  alias start-ssh-agent='eval $(ssh-agent -s); ssh-add ~/.ssh/id_rsa'
fi

start-ssh-agent-if-necessary()
{
  grep -q ENCRYPTED $HOME/.ssh/id_rsa
  if [ "$?" -eq 0 ]; then
    if [ -z ${SSH_AGENT_PID+x} ]; then
      start-ssh-agent
    fi
  fi
}

function tunnel()
{
  start-ssh-agent-if-necessary
  ssh tunnel/"$1"
}
