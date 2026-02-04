#!/usr/bin/env bash
set -euo pipefail

die() { echo "error: $*" >&2; exit 1; }

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="$repo_root/stow/karabiner/.config/karabiner/assets/complex_modifications/disable_right_arrow.json"
dst_dir="$HOME/.config/karabiner/assets/complex_modifications"
dst="$dst_dir/disable_right_arrow.json"

[[ -f "$src" ]] || die "missing: $src"

mkdir -p "$dst_dir"

ts="$(date +%Y%m%d%H%M%S)"
backup_dir="/tmp/dirtyrice-karabiner-disable-right-arrow-$ts"
mkdir -p "$backup_dir"

if [[ -f "$dst" ]]; then
  cp -p "$dst" "$backup_dir/disable_right_arrow.json.bak"
fi

cp -p "$src" "$dst"
echo "installed: $dst"
echo "backups: $backup_dir"
echo
echo "Next: Karabiner-Elements → Complex Modifications → Add rule → enable “Disable broken Right Arrow …”"

