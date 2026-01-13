#!/usr/bin/env sh

source "$CONFIG_DIR/colors.sh"

CURRENT_SPACE=""
if [ -n "$INFO" ]; then
  CURRENT_SPACE="$(echo "$INFO" | jq -r 'map(select(.focused == 1))[0].index // empty' 2>/dev/null)"
fi
if [ -z "$CURRENT_SPACE" ] || [ "$CURRENT_SPACE" = "null" ]; then
  CURRENT_SPACE="$(yabai -m query --spaces --space 2>/dev/null | jq -r '.index' 2>/dev/null)"
fi
INDEX="${NAME#space.}"

if [ -n "$CURRENT_SPACE" ] && [ "$INDEX" = "$CURRENT_SPACE" ]; then
  sketchybar --animate sin 18 --set "$NAME" \
    icon.color=$BASE \
    background.color=$LAVENDER \
    background.border_color=$LAVENDER
else
  sketchybar --animate sin 18 --set "$NAME" \
    icon.color=$SUBTEXT1 \
    background.color=$CLEAR \
    background.border_color=$CLEAR
fi
