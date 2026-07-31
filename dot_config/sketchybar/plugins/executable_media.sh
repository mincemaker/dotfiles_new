#!/bin/sh

# The artwork row of the popup is not handled here — see media_artwork_listener.sh.

POPUP_ITEM="media"
POPUP_CLOSE_DELAY=0.5
CLOSE_TOKEN="/tmp/sketchybar_media_popup_close"

# The popup rows share this script so that hovering them keeps the popup open.
# Everything below the case only concerns the bar item itself.
case "$SENDER" in
  mouse.entered)
    # Cancels a pending close. Crossing from the bar item into the popup, and
    # moving between popup rows, both fire an exit immediately before this.
    rm -f "$CLOSE_TOKEN"
    sketchybar --set "$POPUP_ITEM" popup.drawing=on
    exit 0
    ;;
  # Close after a grace period rather than at once. Closing the instant the
  # cursor leaves is jarring, and the cursor has to cross the gap between the
  # bar item and the popup to reach it at all.
  #
  # mouse.exited.global does not fire when the cursor leaves the popup downwards
  # on the same display, so it cannot carry this on its own; it is kept because
  # it does fire when crossing between displays, which mouse.exited can miss.
  mouse.exited|mouse.exited.global)
    printf '%s' "$$" > "$CLOSE_TOKEN"
    (
      sleep "$POPUP_CLOSE_DELAY"
      # Bail out if an enter cancelled this, or a later exit superseded it.
      # $$ stays the parent script's pid inside a subshell, so it still
      # identifies the invocation that armed this close.
      [ "$(cat "$CLOSE_TOKEN" 2>/dev/null)" = "$$" ] || exit 0
      rm -f "$CLOSE_TOKEN"
      sketchybar --set "$POPUP_ITEM" popup.drawing=off
    ) > /dev/null 2>&1 &
    exit 0
    ;;
esac

[ "$NAME" = "$POPUP_ITEM" ] || exit 0

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
  com.spotify.client) APP_ICON="󰓇"
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
