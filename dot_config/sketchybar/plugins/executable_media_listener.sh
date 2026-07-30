#!/bin/sh

# Bridges media-control's event stream into the media_change_custom event.
# SketchyBar's built-in media_change never fires since macOS 15.4 locked the
# MediaRemote framework behind an entitlement; media-control works around it
# via the entitled /usr/bin/perl.

# Avoid stacking up listeners on config reload. media-control execs
# /usr/bin/perl, so the pattern has to match the flags rather than the binary
# name. Killing the reader makes jq and the while loop below exit on EOF, which
# tears down the rest of the old pipeline.
STREAM_ARGS="stream --no-diff --no-artwork --debounce=500"
pkill -f "mediaremote-adapter.*$STREAM_ARGS" 2>/dev/null

# Fields are joined on U+001F rather than tab: tab counts as IFS whitespace, so
# consecutive tabs would collapse and shift every field after an empty one.
SEP=$(printf '\037')

# shellcheck disable=SC2086
media-control $STREAM_ARGS \
  | jq -r --unbuffered '.payload as $p
      | [$p.playing // false,
         $p.bundleIdentifier // "",
         $p.parentApplicationBundleIdentifier // "",
         $p.title // "",
         $p.artist // "",
         $p.album // ""]
      | map(tostring) | join("\u001f")' \
  | while IFS="$SEP" read -r playing bundle parent title artist album; do
      sketchybar --trigger media_change_custom \
                 MEDIA_PLAYING="$playing" \
                 MEDIA_APP="$bundle" \
                 MEDIA_PARENT="$parent" \
                 MEDIA_TITLE="$title" \
                 MEDIA_ARTIST="$artist" \
                 MEDIA_ALBUM="$album"
    done
