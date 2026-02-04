#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
DEPRECATED: Prefer the dedicated scripts:
  scripts/karabiner-install-hyper.sh
  scripts/karabiner-install-wasd-arrows.sh
  scripts/karabiner-install-disable-right-arrow.sh

This wrapper is kept for convenience/back-compat.
EOF
}

die() {
  echo "error: $*" >&2
  exit 1
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

want_hyper=0
want_wasd=0
want_disable_right=0

if [[ $# -eq 0 ]]; then
  usage
  exit 2
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --hyper) want_hyper=1 ;;
    --wasd-arrows) want_wasd=1 ;;
    --disable-right-arrow) want_disable_right=1 ;;
    *) die "unknown arg: $1" ;;
  esac
  shift
done

if [[ "$want_hyper" -eq 1 ]]; then
  "$repo_root/scripts/karabiner-install-hyper.sh"
fi
if [[ "$want_wasd" -eq 1 ]]; then
  "$repo_root/scripts/karabiner-install-wasd-arrows.sh"
fi
if [[ "$want_disable_right" -eq 1 ]]; then
  "$repo_root/scripts/karabiner-install-disable-right-arrow.sh"
fi
