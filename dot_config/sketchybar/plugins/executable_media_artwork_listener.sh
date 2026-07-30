#!/bin/sh

# Drives the artwork row of the media popup.
#
# This is a second stream, separate from media_listener.sh, because the artwork
# does not arrive with the title. MediaRemote publishes it as its own event,
# sometimes a second or more later, and `media-control get` usually does not
# carry it at all — so fetching on a track change misses it, and giving up after
# a few tries means it never appears. Some sources never publish artwork (a
# YouTube ad, or a video scrolled past before the browser finished downloading
# the Media Session image), so there is no point waiting on it either.
#
# Watching the stream instead means the row fills in whenever the artwork turns
# up, however late, and a single sequential loop keeps concurrent fetches from
# overwriting each other while the title changes rapidly.

# --no-diff is deliberate: diff mode emits nothing at startup, which would leave
# the row empty until the next track change. The fingerprint below does the
# de-duplication that diff mode would otherwise provide.
ARGS="stream --no-diff --debounce=1000"

# Avoid stacking up listeners on config reload. The pattern must not match
# media_listener.sh, whose flags differ. media-control execs /usr/bin/perl, so
# match the adapter script rather than the binary name.
pkill -f "mediaremote-adapter.*$ARGS" 2>/dev/null

CACHE="/tmp/sketchybar_media_artwork.jpg"

# Fields are joined on U+001F rather than tab: tab counts as IFS whitespace, so
# consecutive tabs would collapse and shift every field after an empty one.
SEP=$(printf '\037')

LAST=""

# shellcheck disable=SC2086
media-control $ARGS \
  | jq -r --unbuffered '.payload as $p
      | [(($p.artworkData // "") | length | tostring) + ":" + ($p.title // ""),
         ($p.artworkData // "")]
      | join("\u001f")' \
  | while IFS="$SEP" read -r fingerprint data; do
      [ "$fingerprint" = "$LAST" ] && continue
      LAST="$fingerprint"

      # Hide the whole row rather than just the image: it would otherwise leave
      # an empty band above the text.
      if [ -z "$data" ]; then
        sketchybar --set media.artwork drawing=off
        continue
      fi

      TMP=$(mktemp /tmp/sketchybar_media_artwork.XXXXXX)
      printf '%s' "$data" | base64 -d > "$TMP"

      # Normalise to JPEG: sketchybar picks its decoder from the file extension
      # alone and never sniffs the content, so a PNG written to a .jpg path
      # renders nothing.
      if sips -s format jpeg -Z 180 "$TMP" --out "$TMP.jpg" > /dev/null 2>&1; then
        mv -f "$TMP.jpg" "$CACHE"  # atomic, so a hover never sees a partial file
        sketchybar --set media.artwork drawing=on \
                                       background.image="$CACHE" \
                                       background.image.drawing=on
      else
        sketchybar --set media.artwork drawing=off
      fi

      rm -f "$TMP" "$TMP.jpg"
    done
