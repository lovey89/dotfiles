#!/bin/bash

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -la'

alias ..='cd ..'
alias cd..="cd .."

alias efind="find -L . \
    \( \
        ! -type d \
        -o \( \
            ! -name '.git' \
            ! -name 'node_modules' \
            ! -name '.idea' \
            ! \( \
                -name 'target' \
                -exec test -e '{}/CACHEDIR.TAG' \; \
            \) \
            -o -prune \
        \) \
    \) \
    -type f \
    ! -name '*.ipynb' \
    -print0 | xargs -0 grep -I --color=auto -in --"
alias cfind="find -L . \
    \( \
        ! -type d \
        -o \( \
            ! -name '.git' \
            ! -name 'node_modules' \
            ! -name '.idea' \
            ! \( \
                -name 'target' \
                -exec test -e '{}/CACHEDIR.TAG' \; \
            \) \
            -o -prune \
        \) \
    \) \
    -type f \
    ! -name '*.ipynb' \
    -print0 | xargs -0 grep -I -C 10 --color=auto -in --"

# This will make sudo available for aliases as well
alias sudo='sudo '

# If you're behind a proxy and need to authenticate (better than saving your password in a file)
alias proxyauth='curl -sU "$USER" http://www.google.se > /dev/null'

alias genuuid="uuidgen | sed -r -e 's/-//g' -e 's/.*/\U&/'"

alias genrandom="tr -dc a-z0-9 </dev/urandom | head -c 14; echo"

# call with number of characters to produce e.g. "genrandomhex 16"
alias genrandomhex="openssl rand -hex"

# Without --no-x-resources it will get problems with some colors when running
# without -nw. I can't see any difference so I add it by default

alias emacs="emacs --no-x-resources"

if command -v kubectl &> /dev/null; then
  # Only configure this alias if kubectl is installed
  alias k=kubectl
  # Also set up autocompletion for the k command
  complete -F __start_kubectl k
fi

if command -v cargo &> /dev/null; then
  alias rust_lint_crate='cargo clippy --workspace --all-targets -- -D warnings -W clippy::all -W clippy::correctness -W clippy::complexity -W clippy::style -W clippy::suspicious -W clippy::perf' # -W clippy::pedantic
  alias rust_lint_crate_fix='cargo clippy --workspace --all-targets --fix --allow-staged -- -D warnings -W clippy::all -W clippy::correctness -W clippy::complexity -W clippy::style -W clippy::suspicious -W clippy::perf' # -W clippy::pedantic
  alias rust_lint_crate_fix_dirty='cargo clippy --workspace --all-targets --fix --allow-staged --allow-dirty -- -D warnings -W clippy::all -W clippy::correctness -W clippy::complexity -W clippy::style -W clippy::suspicious -W clippy::perf' # -W clippy::pedantic
  #alias rust_fmt_crate='cargo fmt --check -- --config comment_width=100 --config format_code_in_doc_comments=true --config group_imports=StdExternalCrate --config imports_granularity=Module --config imports_layout=Vertical --config wrap_comments=true'
  #alias rust_fmt_crate_fix='cargo fmt -- --config comment_width=100 --config format_code_in_doc_comments=true --config group_imports=StdExternalCrate --config imports_granularity=Module --config imports_layout=Vertical --config wrap_comments=true'
  # I do prefer the formatting from above but right now we are going with "vanilla formatting"
  alias rust_fmt_crate='cargo fmt --check --all'
  alias rust_fmt_crate_fix='cargo fmt --all'
fi

if command -v op.exe &> /dev/null; then
  alias op='op.exe'
fi

if command -v docker &> /dev/null; then
  # Check if '--network host' can be replaced with '-p localhost:8989:8989 -p 8080' during login
  alias dspotify_player='docker run --rm -it \
    -v ~/.dockervolumes/spotify/config/:/app/config/ \
    -v ~/.dockervolumes/spotify/cache/:/app/cache/ \
    --network host \
    aome510/spotify_player:latest'
  if [ -f ~/.kube/config ] && command -v docker &> /dev/null; then
    # '--network host' is necessary if you are using an ssh tunnel to communicate with the cluster
    alias dk9s='docker run --rm -it \
      -v ~/.kube/config:/root/.kube/config:ro \
      -v ~/.dockervolumes/k9s/config/:/root/.config/ \
      -v ~/.dockervolumes/k9s/local/:/root/.local/ \
      --network host \
      -e K9S_SKIN="transparent" \
      derailed/k9s'
  fi
fi

# Functions

decode_base64_url() {
  local len=$((${#1} % 4))
  local result="$1"
  if [ $len -eq 2 ]; then result="$1"'=='
  elif [ $len -eq 3 ]; then result="$1"'='
  fi
  echo "$result" | tr '_-' '/+' | openssl enc -d -base64
}

decode_jwt2() {
  # Decode JWT header
  decode_base64_url $(echo -n $1 | cut -d "." -f 1) | jq .
  # Decode JWT Payload
  decode_base64_url $(echo -n $1 | cut -d "." -f 2) | jq .
}

decode_jwt() {
  echo -n "$1" | jq -R 'split(".") | .[0],.[1] | @base64d | fromjson'
}

alert()
{
  success="$?"
  command="$(history|tail -n1|sed -re 's/^\s*[0-9]+\s*//;s/[;&|]\s*alert$//')"
  # icons can be provided with an absolute path, otherwise they are found under /usr/share/icons
  image="$([ $success = 0 ] && echo terminal || echo error)"
  title="$([ $success = 0 ] && echo Success || echo Failure)"
  body="$([ $success = 0 ] && echo 'Command returned <b>successfully</b>' || echo 'Command returned <b>with an error</b>')"
  # Critical urgency makes the message stay until you click it. the expire-time option doesn't work
  notify-send -u critical -t "0" -i "$image" "$command" "$body"
  # Also see: https://specifications.freedesktop.org/icon-naming-spec/latest/ar01s04.html
  # and https://specifications.freedesktop.org/notification-spec/notification-spec-latest.html
}

cless()
{
  # Every second row will be colored yellow
  sed \
    -e $'0~2s/.*/\033[0;33m&\033[0m/' \
    -e 's/\r//' \
    "$1" | less

#  sed -r $'
#    0~2s/.*/\033[0;33m&\033[0m/
#    s/\r//' "$1" | less
}

lless()
{
  # Every second row will be colored yellow. Also some sections will be highlighted
  sed -r $'
    s/("headers":"([^"]|\\\\.)*")/\033[0;31m\\1\033[0m/
    s/("payload":"([^"]|\\\\.)*")/\033[0;34m\\1\033[0m/
    0~2 {
      s/.*/\033[0;33m&\033[0m/
      s/\033\[0m/\033\[0;33m/g
    }
    s/\r//' "$1" | less
}

extractline()
{
  sed "$2q;d" "$1"
}

countfiles()
{
  RES=$(find . -type f | sed -n 's/..*\.//p' | sort | uniq -c | sort -bnr)
  COUNT=$(echo "$RES" | awk '{s+=$1} END {print s}')
  echo "$RES"
  echo "-----"
  echo "Sum: $COUNT"
}

removetrailingwhitespaces()
{
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i "" 's/[[:blank:]]*$//' "$1"
  else
    sed -i 's/[[:blank:]]*$//' "$1"
  fi
}

zipbase64()
{
  echo "$1" | gzip -c | base64
}

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
  find . \( ! -name ".git" -a ! -name ".idea" -o -prune \) -iname "*$1*"
}

afind() # Needs more testing!
{
  OPTIND=1 # Needed to get getopts to work
  CONTEXT=""
  FILE_ENDING=""
  IGNORE_PATH=""
  FILE_PATH="\( ! -name .git -a ! -name .idea -a ! -path \"*/target/debug\" -a ! -path \"*/target/release\" -o -prune \)"
  REGEX_FLAG=""
  IGNORE_CASE="-i"

  while getopts ":i:t:C:rc" opt; do
    case $opt in
      i)
        IGNORE_PATH="$IGNORE_PATH -a ! -path \*/$OPTARG"
        FILE_PATH="\( ! -name .git -a ! -name .idea -a ! -path \*/$OPTARG -o -prune \)"
        ;;
      t)
        FILE_ENDING="-iname *.$OPTARG"
        ;;
      C)
        CONTEXT="-C $OPTARG"
        ;;
      r)
        REGEX_FLAG="-E"
        ;;
      c)
        IGNORE_CASE=""
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        return
        ;;
      :)
        echo "Option -$OPTARG requires an argument." >&2
        return
        ;;
    esac
  done

  shift $((OPTIND-1))

  # In order to treat the glob expression (*) correctly use the eval command
  #eval "find -L . $FILE_PATH $FILE_ENDING -type f -print0 | xargs -0 grep --color=auto -in \"$1\""
  eval "find -L . \( ! -name .git -a ! -name .idea $IGNORE_PATH -o -prune \) $FILE_ENDING -type f -print0 | xargs -0 grep -I $REGEX_FLAG --color=auto $CONTEXT $IGNORE_CASE -n -- \"$1\""
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

if grep -q "microsoft" /proc/sys/kernel/osrelease; then
  alias xclip='(clip.exe <(cat -))'
fi

if [ "$OSTYPE" == "cygwin" ]; then
  # Output of mvn is broken unless you run with TERM=cygwin
  # http://cygwin.1069669.n5.nabble.com/3-1-x-Mangled-input-output-when-calling-non-cygwin-programs-td149577.html
  alias mvn='TERM=cygwin mvn'

  # Aliases for cygwin (Windows)
  alias winkill='taskkill /PID'
  alias fwinkill='taskkill /F /PID'
  alias winkillall='taskkill /IM'
  alias fwinkillall='taskkill /F /IM'
  #alias killspringboot='fwinkillall java.exe'
  alias ps='ps -W'

  killspringboot()
  {
    PORTS='12780|24180|10880|11180|42460|11280|19780|14580|19780|11190'

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

    #mvn spring-boot:run
    TERM=cygwin mvn verify -Pexec-jar
    killspringboot
    cd -
    trap - INT
  }
fi
