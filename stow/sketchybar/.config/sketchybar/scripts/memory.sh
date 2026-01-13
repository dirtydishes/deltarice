#!/usr/bin/env sh

# "Used" memory approximation that matches Activity Monitor reasonably well:
# used ≈ active + wired + compressed
# Also detects correct VM page size (Apple Silicon is often 16384 bytes).

TOTAL_BYTES="$(/usr/sbin/sysctl -n hw.memsize 2>/dev/null)"

VM_OUT="$(/usr/bin/vm_stat 2>/dev/null)"
PAGE_SIZE="$(printf '%s
' "$VM_OUT" | /usr/bin/awk '
  /page size of/ {
    for (i=1; i<=NF; i++) {
      v=$i;
      gsub(/[^0-9]/, "", v);
      if (v != "") { print v; exit }
    }
  }
')"

USED_BYTES="$(printf '%s
' "$VM_OUT" | /usr/bin/awk -v ps="$PAGE_SIZE" '
  function num(x) { gsub(/[^0-9]/, "", x); return (x==""?0:x) }
  /Pages active/ { active = num($NF) }
  /Pages wired down/ { wired = num($NF) }
  /Pages occupied by compressor/ { comp = num($NF) }
  END {
    if (ps == "" || ps == 0) ps = 4096;
    printf "%.0f", (active + wired + comp) * ps;
  }
')"

if [ -z "$TOTAL_BYTES" ] || [ -z "$USED_BYTES" ]; then
  sketchybar --set "$NAME" label="--"
  exit 0
fi

USED_GB="$(/usr/bin/awk -v u="$USED_BYTES" 'BEGIN {printf "%.1f", u/1024/1024/1024}')"
TOTAL_GB="$(/usr/bin/awk -v t="$TOTAL_BYTES" 'BEGIN {printf "%.0f", t/1024/1024/1024}')"

sketchybar --set "$NAME" label="${USED_GB}/${TOTAL_GB}G"
