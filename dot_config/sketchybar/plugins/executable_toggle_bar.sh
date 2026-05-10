#!/bin/sh

HIDDEN=$(sketchybar --query bar | grep hidden | cut -d'"' -f4)

if [ "$HIDDEN" = "on" ]; then
  sketchybar --bar hidden=off
  osascript -e 'tell application "System Events" to set autohide menu bar of dock preferences to true'
else
  sketchybar --bar hidden=on
  osascript -e 'tell application "System Events" to set autohide menu bar of dock preferences to false'
fi
