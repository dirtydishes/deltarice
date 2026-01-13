#!/usr/bin/env sh

VOL="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
MUTED="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)"

if [ "$MUTED" = "true" ]; then
  sketchybar --set "$NAME" icon="" label="mute"
  exit 0
fi

if [ -z "$VOL" ]; then
  VOL="--"
fi

ICON=""
if [ "$VOL" != "--" ] && [ "$VOL" -le 0 ] 2>/dev/null; then
  ICON=""
elif [ "$VOL" != "--" ] && [ "$VOL" -le 33 ] 2>/dev/null; then
  ICON=""
elif [ "$VOL" != "--" ] && [ "$VOL" -le 66 ] 2>/dev/null; then
  ICON=""
fi

sketchybar --set "$NAME" icon="$ICON" label="${VOL}%"
