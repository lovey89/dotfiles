#!/bin/sh

# Script to convert a color scheme in xresources to .minttyrc format (for
# cygwin). Can also handle when the colors are located in a variable

getColor() {
  POSSIBLE_COLOR=$(sed -rn 's/.*'$1':\s*([^\s]*)/\1/p' $FILE)

  if [ ${POSSIBLE_COLOR:0:1} = "#" ]; then
    # The color code should start with "#"
    echo $POSSIBLE_COLOR
  else
    # Else I will treat it as a variable
    getColorVar "$POSSIBLE_COLOR"
  fi
}

getColorVar() {
  POSSIBLE_COLOR=$(sed -rn 's/\s*#define\s+'$1'\s+([^\s]*)/\1/p' $FILE)
  if [ ${POSSIBLE_COLOR:0:1} = "#" ]; then
    # The color code should start with "#"
    echo $POSSIBLE_COLOR
  else
    # Else I will treat it as a variable
    getColorVar "$POSSIBLE_COLOR"
  fi
}

if [ "$#" != 1 ]; then
  echo "Wrong number of arguments" 1>&2
  exit 1
elif [ ! -r "$1" ]; then
  echo "Can't read the file: $1" 1>&2
  exit 2
fi

FILE="$1"

printf "# Don't update this file directly. Update\n"
printf "# xresources2minttyrc.sh which can generate\n"
printf "# the color scheme from an xresources file\n"
printf "# -----------------------------------------\n"

printf "\n"

printf "BoldAsFont=-1\n"
printf "BellType=0\n"
printf "Term=xterm-256color\n"
printf "CursorBlinks=no\n"

printf "\n"

printf "# The color codes are generated from the file: %s\n" $(basename "$1")

col=$(getColor "foreground")
printf "ForegroundColour = %s\n" "$col"
col=$(getColor "background")
printf "BackgroundColour = %s\n" "$col"
col=$(getColor "cursorColor")
printf "CursorColour     = %s\n" "$col"
col=$(getColor "color0")
printf "Black            = %s\n" "$col"
col=$(getColor "color8")
printf "BoldBlack        = %s\n" "$col"
col=$(getColor "color1")
printf "Red              = %s\n" "$col"
col=$(getColor "color9")
printf "BoldRed          = %s\n" "$col"
col=$(getColor "color2")
printf "Green            = %s\n" "$col"
col=$(getColor "color10")
printf "BoldGreen        = %s\n" "$col"
col=$(getColor "color3")
printf "Yellow           = %s\n" "$col"
col=$(getColor "color11")
printf "BoldYellow       = %s\n" "$col"
col=$(getColor "color4")
printf "Blue             = %s\n" "$col"
col=$(getColor "color12")
printf "BoldBlue         = %s\n" "$col"
col=$(getColor "color5")
printf "Magenta          = %s\n" "$col"
col=$(getColor "color13")
printf "BoldMagenta      = %s\n" "$col"
col=$(getColor "color6")
printf "Cyan             = %s\n" "$col"
col=$(getColor "color14")
printf "BoldCyan         = %s\n" "$col"
col=$(getColor "color7")
printf "White            = %s\n" "$col"
col=$(getColor "color15")
printf "BoldWhite        = %s\n" "$col"
