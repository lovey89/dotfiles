#!/usr/bin/env bash

# Script to convert a color scheme in xresources to wezterm format (for
# wezterm terminal). Can also handle when the colors are located in a variable

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

background=$(getColor "background")
foreground=$(getColor "foreground")
color0=$(getColor "color0")
color1=$(getColor "color1")
color2=$(getColor "color2")
color3=$(getColor "color3")
color4=$(getColor "color4")
color5=$(getColor "color5")
color6=$(getColor "color6")
color7=$(getColor "color7")
color8=$(getColor "color8")
color9=$(getColor "color9")
color10=$(getColor "color10")
color11=$(getColor "color11")
color12=$(getColor "color12")
color13=$(getColor "color13")
color14=$(getColor "color14")
color15=$(getColor "color15")


echo "[colors]"
echo "foreground = '$foreground'"
echo "background = '$background'"
echo "cursor_bg = '$foreground'"
echo "cursor_fg = '$background'"
echo "cursor_border = '$foreground'"
echo "selection_fg = '$background'"
echo "selection_bg = '$foreground'"
echo "ansi = [ '$color0', '$color1', '$color2', '$color3', '$color4', '$color5', '$color6', '$color7' ]"
echo "brights = [ '$color8', '$color9', '$color10', '$color11', '$color12', '$color13', '$color14', '$color15' ]"
echo ""
echo "[metadata]"
echo "aliases = []"
echo "author = ''"
echo "name = '$(basename $FILE)'"