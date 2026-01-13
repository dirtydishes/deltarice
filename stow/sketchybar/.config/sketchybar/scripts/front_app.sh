#!/usr/bin/env sh

source "$CONFIG_DIR/colors.sh"

APP=""
if [ "$SENDER" = "front_app_switched" ] && [ -n "$INFO" ]; then
  APP="$INFO"
else
  APP="$(yabai -m query --windows --window 2>/dev/null | jq -r '.app' 2>/dev/null)"
fi

if [ -z "$APP" ] || [ "$APP" = "null" ]; then
  APP="Desktop"
fi

sketchybar --animate sin 16 --set "$NAME" \
  label="$APP" \
  icon.background.image="app.$APP" \
  icon.color=$LAVENDER
