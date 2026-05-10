#!/bin/bash

# Standard colors to match existing bar
WHITE=0xffffffff
DANGER=0xffff7b7b

TOTAL_MEMORY=$(sysctl -n hw.memsize)
PAGE_SIZE=$(vm_stat | awk '/page size of/ {print $8}' | sed 's/\.//')

USED_MEMORY=$(vm_stat | awk -v page="$PAGE_SIZE" '
  /Pages active:/ { active = $3 }
  /Pages wired down:/ { wired = $4 }
  /Pages occupied by compressor:/ { compressed = $5 }
  END {
    gsub(/\./, "", active); gsub(/\./, "", wired); gsub(/\./, "", compressed)
    print (active + wired + compressed) * page
  }
')

PERCENTAGE=$((USED_MEMORY * 100 / TOTAL_MEMORY))

if [ "$PERCENTAGE" -ge 80 ]; then
  COLOR="$DANGER"
else
  COLOR="$WHITE"
fi

sketchybar --set "$NAME" \
  label="${PERCENTAGE}%" \
  label.color="$COLOR" \
  icon.color="$COLOR" \
  icon="" \
  icon.padding_right=6
