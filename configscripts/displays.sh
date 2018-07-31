#!/bin/bash

xrandr | grep -q "HDMI-0 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 1280mm x 720mm"

if [ "$?" -eq 0 ]; then
  echo "TV output: off"
  xrandr --output HDMI-0 --off
else
  echo "TV output: on"
  xrandr --output HDMI-0 --auto --same-as DVI-D-0
fi

