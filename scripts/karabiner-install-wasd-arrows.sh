#!/usr/bin/env bash
set -euo pipefail

die() { echo "error: $*" >&2; exit 1; }

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="$repo_root/stow/karabiner/.config/karabiner/assets/complex_modifications/hyper_wasd_arrows.json"
dst_dir="$HOME/.config/karabiner/assets/complex_modifications"
dst="$dst_dir/hyper_wasd_arrows.json"

[[ -f "$src" ]] || die "missing: $src"

mkdir -p "$dst_dir"

ts="$(date +%Y%m%d%H%M%S)"
backup_dir="/tmp/dirtyrice-karabiner-wasd-$ts"
mkdir -p "$backup_dir"

if [[ -f "$dst" ]]; then
  cp -p "$dst" "$backup_dir/hyper_wasd_arrows.json.bak"
fi

cp -p "$src" "$dst"
echo "installed: $dst"

# Avoid conflict with default skhd swap-mode (Hyper+s).
skhdrc="$HOME/.skhdrc"
[[ -f "$skhdrc" ]] || die "missing: $skhdrc (expected skhd config at ~/.skhdrc)"
cp -p "$skhdrc" "$backup_dir/skhdrc.bak"

python3 - "$skhdrc" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text()
new = text

# Move swap mode entry from Hyper+s to Hyper+e
new = re.sub(
    r'^(ctrl \+ alt \+ cmd \+ shift - )s(\s*;\s*swap\s*)$',
    r'\1e\2',
    new,
    flags=re.M,
)

# Ensure pressing "e" in swap mode exits swap
new = re.sub(r'^(swap < )s(\s*;\s*default\s*)$', r'\1e\2', new, flags=re.M)

# Add Hyper+e as an exit chord in swap mode for convenience
exit_line = 'swap < ctrl + alt + cmd + shift - e ; default\n'
if exit_line not in new:
    marker = 'swap < e ; default\n'
    if marker in new:
        new = new.replace(marker, marker + exit_line, 1)

if new == text:
    print("WARN: ~/.skhdrc swap-mode lines not changed (already updated?)")
else:
    path.write_text(new)
    print("updated:", path)
PY

echo "backups: $backup_dir"
echo
echo "Next:"
echo "- Karabiner-Elements → Complex Modifications → Add rule → enable “Hyper + WASD …”"
echo "- Reload skhd: skhd --reload (or restart its service)"

