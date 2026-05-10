#!/bin/bash

# Standard colors to match existing bar
WHITE=0xffffffff
DANGER=0xffff7b7b

# Prevent multiple instances
LOCKFILE="/tmp/sketchybar_cpu.lock"
if [ -f "$LOCKFILE" ]; then
  exit 0
fi
echo $$ >"$LOCKFILE"

# Clean up lock on exit
trap 'rm -f "$LOCKFILE"' EXIT

# Get CPU usage from top -l 1
CPU_LINE=$(top -l 1 | grep "CPU usage:")
IDLE=$(echo "$CPU_LINE" | awk '{print $7}' | sed 's/%//')
USAGE=$((100 - ${IDLE%.*}))

if [ "$USAGE" -lt 0 ]; then USAGE=0; fi
if [ "$USAGE" -gt 100 ]; then USAGE=100; fi

if [ "$USAGE" -ge 80 ]; then
  COLOR="$DANGER"
else
  COLOR="$WHITE"
fi

sketchybar --set "$NAME" \
  icon="" \
  label="${USAGE}%" \
  label.color="$COLOR" \
  icon.color="$COLOR" \
  icon.padding_right=6
