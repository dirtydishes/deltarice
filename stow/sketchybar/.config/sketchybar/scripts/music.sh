#!/bin/bash

song=$(osascript -e 'tell application "Music" to if player state is playing then name of current track & " — " & artist of current track')

if [ "$song" = "" ]; then
  sketchybar --set $NAME label="Paused"
else
  sketchybar --set $NAME label="$song"
fi
