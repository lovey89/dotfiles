#!/bin/bash

NAME=$(basename -- "$0")
CARD=0

usage() {
  cat <<EOF >&2
Usage:
  $NAME [-c <card_no>] 0 : Speakers on sound card <card_no>
  $NAME [-c <card_no>] 1 : Headphones on sound card <card_no>
  $NAME [-c <card_no>] 2 : Both speakers and headphones on sound card <card_no>
  $NAME [-c <card_no>]   : Toggle between speakers and headphones on sound card <card_no>
EOF
  exit
}

while getopts ":c:h" opt; do
  case $opt in
    c)
      if ! [[ $OPTARG =~ ^[0-9]+$ ]]; then
        echo "error: Not a number" >&2;
        exit 1
      fi
      CARD="$OPTARG"
      ;;
    h)
      usage
      ;;
    \?)
      # Unknown option
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      # Argument missing. The option expects an argument
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

set_sound_source()
{
  SOUND_SOURCE=$1
  FRONT_LEVEL=$2
  HEADPHONE_LEVEL=$3

  pacmd set-sink-port 1 $SOUND_SOURCE
  amixer -c$CARD set Front ${FRONT_LEVEL}% > /dev/null
  amixer -c$CARD set Headphone ${HEADPHONE_LEVEL}% > /dev/null
}

command -v amixer >/dev/null 2>&1 || { echo "amixer not installed" >&2; exit 1; }
command -v pacmd >/dev/null 2>&1 || { echo "pacmd not installed" >&2; exit 1; }

amixer -c$CARD sset "Auto-Mute Mode" Disabled > /dev/null

if [ -z $1 ]; then
  amixer -c$CARD get Headphone | grep -q -F '[0%]'
  if [ "$?" -eq 0 ]; then
    # The headphones are off
    set_sound_source analog-output-headphones 0 100
    echo "Output: Headphones"
  else
    set_sound_source analog-output-lineout 100 0
    echo "Output: Front speakers"
  fi
elif [ "$1" -eq 0 ] 2> /dev/null; then
  set_sound_source analog-output-lineout 100 0
  echo "Output: Front speakers"
elif [ "$1" -eq 1 ] 2> /dev/null; then
  set_sound_source analog-output-headphones 0 100
  echo "Output: Headphones"
elif [ "$1" -eq 2 ] 2> /dev/null; then
  set_sound_source analog-output-headphones 100 100
  echo "Output: Both"
else
  echo "Wrong input:" >&2
  usage
  exit 1
fi
