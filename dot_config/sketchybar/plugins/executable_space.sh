#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

if [ -z "$FOCUSED_WORKSPACE" ]; then
    FOCUSED_WORKSPACE=$(paneru query active --json | jq -r '.virtual_workspace_number')
fi

WINDOW_COUNT=$(paneru query virtual-workspaces --json | jq --argjson n "$1" '[.[] | select(.number == $n) | .windows | length] | add // 0')

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" background.drawing=on label.color=0xffffffff
elif [ "$WINDOW_COUNT" -gt 0 ]; then
    sketchybar --set "$NAME" background.drawing=off label.color=0xffffffff
else
    sketchybar --set "$NAME" background.drawing=off label.color=0x44ffffff
fi
