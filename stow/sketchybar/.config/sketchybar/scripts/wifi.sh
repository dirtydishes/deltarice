#!/usr/bin/env sh

AIRPORT_BIN="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

WIFI_DEV="$(/usr/sbin/networksetup -listallhardwareports 2>/dev/null | /usr/bin/awk '
  $0 ~ /^Hardware Port: Wi-Fi/ {found=1}
  found && $1 == "Device:" {print $2; exit}
')"

# Fallback for odd naming/localization
if [ -z "$WIFI_DEV" ]; then
  WIFI_DEV="$(/usr/sbin/networksetup -listallhardwareports 2>/dev/null | /usr/bin/awk '
    $0 ~ /^Hardware Port:.*(Wi-Fi|AirPort)/ {found=1}
    found && $1 == "Device:" {print $2; exit}
  ')"
fi

[ -z "$WIFI_DEV" ] && WIFI_DEV="en0"

POWER="$(/usr/sbin/networksetup -getairportpower "$WIFI_DEV" 2>/dev/null | /usr/bin/awk '{print $NF}')"
if [ "$POWER" != "On" ]; then
  sketchybar --set "$NAME" label="Off"
  exit 0
fi

SSID=""
if [ -x "$AIRPORT_BIN" ]; then
  SSID="$("$AIRPORT_BIN" -I 2>/dev/null | /usr/bin/awk -F': ' '/^[[:space:]]*SSID:/ {print $2; exit}')"
fi

# Use IP presence as the "online" signal
IP="$(/usr/sbin/ipconfig getifaddr "$WIFI_DEV" 2>/dev/null)"

if [ -z "$SSID" ]; then
  SSID="Wi-Fi"
fi

if [ -z "$IP" ]; then
  sketchybar --set "$NAME" label="Offline"
else
  sketchybar --set "$NAME" label="$SSID"
fi
