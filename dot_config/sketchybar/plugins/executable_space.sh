#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

if [ -z "$FOCUSED_WORKSPACE" ]; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi

WINDOW_COUNT=$(aerospace list-windows --count --workspace "$1")

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" background.drawing=on label.color=0xffffffff
elif [ "$WINDOW_COUNT" -gt 0 ]; then
    sketchybar --set "$NAME" background.drawing=off label.color=0xffffffff
else
    sketchybar --set "$NAME" background.drawing=off label.color=0x44ffffff
fi
