#!/usr/bin/sh

# -e: Exit immediately if a pipeline, a list, or a compound command, exits with
#     a non-zero status.
# -u: Treat unset variables and parameters other than the special parameters "@"
#     and "*" as an error when performing parameter expansion.
set -eu

highlight_command='highlight -s dusk -O truecolor --failsafe'

guess_language() {
  lang=$(echo -e ${1:-} | file - | cut -d" " -f2)
  if [ "$lang" = "a" ]; then
    # The output can be on the format: "/dev/stdin: a /usr/bin/sh script, ASCII text executable"
    lang=$(echo -e ${1:-} | file - | cut -d" " -f3)
  fi
  lang=$(tr [A-Z] [a-z] <<< "$lang") # make lowercase
  lang="${lang##*/}" # in the case of something like "/usr/bin/sh" it will be replaced with "sh"
  case "$lang" in
    "bourne-again")
      echo "bash"
      ;;
    "posix")
      echo "sh"
      ;;
    *)
      echo "$lang"
      ;;
  esac
}

# check if the language passed as $1 is known to source-highlight
check_language_is_known() {
  lang=$(source-highlight --lang-list | cut -d' ' -f1 | grep "^${1:-}$" || true)
  echo $lang
}

if [ "$1" != "-" -a ! -e "$1" ] ; then
  exit 1
fi

if [ "$1" != "-" -a -d "$1" ] ; then
  ls -alF -- "$1"
  exit $?
fi

case "$1" in
  *ChangeLog|*changelog)
    if [ -x "$(command -v source-highlight)" ]; then
      source-highlight --failsafe -f esc --lang-def=changelog.lang --style-file=esc.style -i "$1"
    fi
    ;;
  *Makefile|*makefile)
    if [ -x "$(command -v highlight)" ]; then
      $highlight_command "$1"
    else
      source-highlight --failsafe -f esc --lang-def=makefile.lang --style-file=esc.style -i "$1"
    fi
    ;;
  *.tar|*.tgz|*.gz|*.bz2|*.xz)
    if [ -x "$(command -v lesspipe.sh)" ]; then
      lesspipe.sh "$1"
    elif [ -x "$(command -v lesspipe)" ]; then
      lesspipe "$1"
    else
      exit 1
    fi
    ;;
  -) # standard in. When we pipe the output to less
    if [ -x "$(command -v highlight)" ]; then
      cat | $highlight_command
    else
      IFS= file=$(cat)
      lang=$(guess_language "$file")
      #echo $lang
      lang=$(check_language_is_known "$lang")
      #echo "Confirmed $lang"
      if [ -n "$lang" ]; then
        echo $file | source-highlight --failsafe -f esc --src-lang=$lang --style-file=esc.style
      else
        echo $file
      fi
    fi
    ;;
  *) # Most files will be caught here
    # the 'highlight' command seems to produce better result!
    if [ -x "$(command -v highlight)" ]; then
      $highlight_command "$1"
    else
      source-highlight --failsafe --infer-lang -f esc --style-file=esc.style -i "$1"
    fi
    ;;
esac
