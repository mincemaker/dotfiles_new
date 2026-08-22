#!/bin/sh

# Bridges paneru's `subscribe --json` event stream into SketchyBar's own event
# system. paneru has no declarative "exec on workspace change" hook (unlike
# aerospace's exec-on-workspace-change), so this script is the equivalent
# glue, mirroring media_listener.sh's approach for media-control.

pkill -f "paneru subscribe --json" 2>/dev/null

# paneru restarting (crash, `paneru restart`, launchd reload) closes this pipe
# and kills the loop below, silently freezing SketchyBar's workspace display.
# Reconnect indefinitely instead of exiting.
while true; do
  paneru subscribe --json \
    | jq -r --unbuffered '
        select(.event == "virtual_workspace_changed" or .event == "windows_changed")
        | .active.virtual_workspace_number // empty' \
    | while IFS= read -r focused; do
        sketchybar --trigger paneru_workspace_change FOCUSED_WORKSPACE="$focused"
      done
  sleep 1
done
