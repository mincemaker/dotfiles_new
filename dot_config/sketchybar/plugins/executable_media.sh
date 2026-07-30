#!/bin/sh

# The artwork row of the popup is not handled here — see media_artwork_listener.sh.

case "$SENDER" in
  mouse.entered)
    sketchybar --set "$NAME" popup.drawing=on
    exit 0
    ;;
  # Only the global variant closes the popup. Plain mouse.exited fires the
  # moment the cursor leaves the bar item for the popup below it, which would
  # make the popup impossible to reach.
  mouse.exited.global)
    sketchybar --set "$NAME" popup.drawing=off
    exit 0
    ;;
esac

# The media_change_custom event is triggered by plugins/media_listener.sh, which
# passes the now playing state in as environment variables.
if [ "$SENDER" = "media_change_custom" ]; then
  PLAYING="$MEDIA_PLAYING"
  APP="$MEDIA_APP"
  PARENT="$MEDIA_PARENT"
  TITLE="$MEDIA_TITLE"
  ARTIST="$MEDIA_ARTIST"
  ALBUM="$MEDIA_ALBUM"
else
  # Forced update, e.g. right after a config reload. Ask media-control directly.
  # See media_listener.sh for why the fields are joined on U+001F.
  SEP=$(printf '\037')
  FIELDS=$(media-control get --no-artwork 2>/dev/null | jq -r '
    [.playing // false,
     .bundleIdentifier // "",
     .parentApplicationBundleIdentifier // "",
     .title // "",
     .artist // "",
     .album // ""]
    | map(tostring) | join("\u001f")' 2>/dev/null)

  IFS="$SEP" read -r PLAYING APP PARENT TITLE ARTIST ALBUM <<EOF
$FIELDS
EOF
fi

if [ -z "$TITLE" ]; then
  sketchybar --set "$NAME" drawing=off popup.drawing=off
  exit 0
fi

# Safari reports com.apple.WebKit.GPU as its bundle id, so prefer the parent.
case "${PARENT:-$APP}" in
  com.spotify.client) APP_ICON=""
  ;;
  com.apple.Music) APP_ICON="󰝚"
  ;;
  com.google.Chrome|app.zen-browser.zen|com.apple.Safari|org.mozilla.*|com.brave.Browser|company.thebrowser.Browser) APP_ICON="󰗃"
  ;;
  *) APP_ICON="󰎆"
esac

# On the bar the icon doubles as the play state, and the item stays visible
# while paused so the click target remains reachable. The popup keeps showing
# the source app instead, since the bar already carries the state.
ICON="$APP_ICON"
[ "$PLAYING" != "true" ] && ICON="󰏤"

LABEL="$TITLE"
[ -n "$ARTIST" ] && LABEL="$TITLE - $ARTIST"

sketchybar --set "$NAME" drawing=on icon="$ICON" label="$LABEL" \
           --set media.title icon="$APP_ICON" label="$TITLE" \
           --set media.artist label="$ARTIST" \
                              drawing="$([ -n "$ARTIST" ] && echo on || echo off)" \
           --set media.album label="$ALBUM" \
                             drawing="$([ -n "$ALBUM" ] && echo on || echo off)"
