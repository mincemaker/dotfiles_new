#!/bin/bash

# Standard colors to match existing bar
WHITE=0xffffffff
DANGER=0xffff7b7b

SSID=$(system_profiler SPAirPortDataType | awk '/Current Network Information:/ { getline; print substr($0, 13, (length($0) - 13)); exit }')

if [ "$SSID" = "" ]; then
  sketchybar --set "$NAME" \
    icon="󰤭" \
    label="" \
    icon.color="${DANGER}"
else
  sketchybar --set "$NAME" \
    icon="" \
    label="" \
    icon.color="${WHITE}"
fi
