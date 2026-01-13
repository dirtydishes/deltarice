#!/usr/bin/env sh

source "$CONFIG_DIR/colors.sh"

TITLE="$(nowplaying-cli get title 2>/dev/null | head -n 1)"
ARTIST="$(nowplaying-cli get artist 2>/dev/null | head -n 1)"

if [ -z "$TITLE" ] || [ "$TITLE" = "null" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

LABEL="$TITLE"
if [ -n "$ARTIST" ] && [ "$ARTIST" != "null" ]; then
  LABEL="$TITLE — $ARTIST"
fi

sketchybar --set "$NAME" drawing=on label="$LABEL" icon.color=$LAVENDER
