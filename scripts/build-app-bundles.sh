#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Build .app bundles for macOS Privacy & Security permissions.

Why:
  macOS Privacy & Security UI often won’t list Homebrew-installed CLI binaries.
  Wrapping yabai/skhd/borders into stable .app bundles makes it easier to grant:
  - Accessibility (yabai/skhd/borders)
  - Input Monitoring (skhd + Hyperkey)
  - Screen Recording (yabai, if you use window animations)

This script creates:
  ~/Applications/Yabai.app   (Contents/MacOS/yabai)
  ~/Applications/Skhd.app    (Contents/MacOS/skhd)
  ~/Applications/Borders.app (Contents/MacOS/borders)

It copies the currently installed binaries from PATH (typically Homebrew) into the app bundles.
It then ad-hoc codesigns the bundles (no Developer ID required).

Usage:
  scripts/build-app-bundles.sh
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "missing required command: $cmd" >&2
    exit 1
  fi
}

require_cmd codesign

make_app() {
  local app_name="$1"      # e.g. Yabai
  local exe_name="$2"      # e.g. yabai
  local bundle_id="$3"     # e.g. dev.kell.rice.yabai
  local src_bin="$4"       # absolute path

  local dest_root="$HOME/Applications"
  local dest_app="$dest_root/${app_name}.app"
  local dest_contents="$dest_app/Contents"
  local dest_macos="$dest_contents/MacOS"

  mkdir -p "$dest_root"

  if [[ -e "$dest_app" ]]; then
    local ts
    ts="$(date +%Y%m%d-%H%M%S)"
    mv "$dest_app" "$dest_app.bak-$ts"
  fi

  mkdir -p "$dest_macos"

  cp -f "$src_bin" "$dest_macos/$exe_name"
  chmod +x "$dest_macos/$exe_name"

  cat >"$dest_contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>$exe_name</string>
  <key>CFBundleIdentifier</key>
  <string>$bundle_id</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>$app_name</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>CFBundleVersion</key>
  <string>1</string>
</dict>
</plist>
EOF

  # Ad-hoc sign so TCC permissions attach to a stable code identity.
  # This does not require a Developer ID certificate.
  codesign --force --deep --sign - "$dest_app" >/dev/null 2>&1 || true

  # Remove quarantine attribute if present.
  if command -v xattr >/dev/null 2>&1; then
    xattr -dr com.apple.quarantine "$dest_app" >/dev/null 2>&1 || true
  fi

  echo "built: $dest_app"
}

resolve_bin() {
  local exe="$1"
  local bin
  bin="$(command -v "$exe" || true)"
  if [[ -z "$bin" ]]; then
    echo "missing $exe in PATH" >&2
    exit 1
  fi
  echo "$bin"
}

yabai_bin="$(resolve_bin yabai)"
skhd_bin="$(resolve_bin skhd)"
borders_bin="$(resolve_bin borders)"

make_app "Yabai" "yabai" "dev.kell.rice.yabai" "$yabai_bin"
make_app "Skhd" "skhd" "dev.kell.rice.skhd" "$skhd_bin"
make_app "Borders" "borders" "dev.kell.rice.borders" "$borders_bin"

cat <<'EOF'

Next:
  System Settings → Privacy & Security:
    - Accessibility: enable Yabai.app, Skhd.app, Borders.app
    - Input Monitoring: enable Skhd.app and Hyperkey.app
    - Screen Recording: enable Yabai.app (if using window animations)

Then restart services:
  launchctl kickstart -k gui/$(id -u)/com.koekeishiya.yabai
  launchctl kickstart -k gui/$(id -u)/com.koekeishiya.skhd
  launchctl kickstart -k gui/$(id -u)/homebrew.mxcl.borders
  launchctl kickstart -k gui/$(id -u)/homebrew.mxcl.sketchybar
EOF
