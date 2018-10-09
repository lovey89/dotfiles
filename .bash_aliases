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

alias genuuid="uuidgen | sed -r -e 's/-//g' -e 's/.*/\U&/'"

# Functions

unzipbase64()
{
  echo "$1" | base64 -d | gunzip
}

prettyunzipbase64()
{
  UNZIPPED=$(unzipbase64 "$1")

  TYPE=$(echo $UNZIPPED | sed -r '
    :a;$ ! b a
    /^</ {
      s/.*/XML/
      q
    }
    /^\{/ {
      s/.*/JSON/
      q
    }
    /^[^<\{]/ s/.*/NONE/')

  if [ "$TYPE" = "XML" ]; then
    RESULT=$(echo "$UNZIPPED" | xmllint --format - 2> /dev/null)
    if [ "$?" != 0 ]; then
      echo "$UNZIPPED"
    else
      echo "$RESULT"
    fi
  elif [ "$TYPE" = "JSON" ]; then
    RESULT=$(echo "$UNZIPPED" | python -mjson.tool 2> /dev/null)
    if [ "$?" != 0 ]; then
      echo "$UNZIPPED"
    else
      echo "$RESULT"
    fi
  else
    echo "$UNZIPPED"
  fi
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

alias start-ssh-agent='eval $(ssh-agent -s); ssh-add ~/.ssh/id_rsa'

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

secondstodate()
{
  date --date "@${1:0:10}"
}

if [ "$OSTYPE" == "cygwin" ]; then
  # Aliases for cygwin (Windows)
  alias winkill='taskkill /PID'
  alias fwinkill='taskkill /F /PID'
  alias winkillall='taskkill /IM'
  alias fwinkillall='taskkill /F /IM'
  #alias killspringboot='fwinkillall java.exe'
  alias ps='ps -W'

  killspringboot()
  {
    PORTS='12780|24180|10880|11180|42460|11280|19780|14580|19780'

    PIDS=$(netstat -aon | sed -n -r '
      s/^ *TCP +0.0.0.0:('"$PORTS"') +0.0.0.0:0 +LISTENING +([0-9]+).*/\2/
      t a
      b b
      :a s/.*/\/PID &/
      H
      :b $ {
        x
        s/\n/ /gp
      }')

    if [ -n "$PIDS" ]; then
      taskkill /F $PIDS
    else
      echo "Spring boot doesn't seem to run"
    fi
  }

  runspringboot()
  {
    trap ' ' INT
    GIT_ROOT_DIR=$(git rev-parse --show-toplevel 2> /dev/null)
    if [ "$?" -ne 0 ]; then
      echo "Not a git repository" 1>&2
      return 1
    fi
    cd "${GIT_ROOT_DIR}/app"

    mvn spring-boot:run
    killspringboot
    cd -
    trap - INT
  }
fi
