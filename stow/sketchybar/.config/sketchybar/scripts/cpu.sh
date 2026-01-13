#!/usr/bin/env sh

# Report overall system CPU usage as 0–100% (matches Activity Monitor style).
# Avoids ps-sum reporting >100% on multi-core systems.

CPU_LINE="$(/usr/bin/top -l 2 -n 0 2>/dev/null | /usr/bin/awk '/CPU usage/ {line=$0} END {print line}')"

CPU_PCT="$(printf '%s' "$CPU_LINE" | /usr/bin/awk -F'[:,]' '
  {
    user=$2; sys=$3;
    gsub(/[^0-9.]/, "", user);
    gsub(/[^0-9.]/, "", sys);
    if (user == "") user = 0;
    if (sys  == "") sys  = 0;
    printf "%d", (user + sys + 0.5);
  }
')"

[ -z "$CPU_PCT" ] && CPU_PCT=0

sketchybar --set "$NAME" label="${CPU_PCT}%"
