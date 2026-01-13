#!/usr/bin/env sh

INFO="$(pmset -g batt 2>/dev/null | tail -n 1)"
PCT="$(echo "$INFO" | grep -oE '[0-9]+%' | head -n 1 | tr -d '%')"
STATE="$(echo "$INFO" | grep -oE 'charging|discharging|charged' | head -n 1)"

if [ -z "$PCT" ]; then
  sketchybar --set "$NAME" label="--"
  exit 0
fi

ICON=""
if [ "$PCT" -le 10 ]; then ICON="";
elif [ "$PCT" -le 25 ]; then ICON="";
elif [ "$PCT" -le 50 ]; then ICON="";
elif [ "$PCT" -le 75 ]; then ICON="";
fi

if [ "$STATE" = "charging" ]; then
  ICON=""
fi

sketchybar --set "$NAME" icon="$ICON" label="${PCT}%"
