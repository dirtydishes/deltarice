# macOS Rice Cheat Sheet

```
    _/\_          yabai + skhd + SketchyBar + Borders
   /    \         one keyboard, many windows
  /_/\/\_\
```

A practical “how to drive it” reference for this machine’s current setup.

## Table of contents

- [Versions](#versions)
- [Config locations](#config-locations)
- [Service control](#service-control)
- [Permissions](#permissions)
- [Spaces + scripting addition (SA)](#spaces--scripting-addition-sa)
- [Keybinds (skhd)](#keybinds-skhd)
- [Menu bar + app menus](#menu-bar--app-menus)
- [Window management (yabai)](#window-management-yabai)
- [SketchyBar stats](#sketchybar-stats)
- [Karabiner rules](#karabiner-rules)
- [Troubleshooting](#troubleshooting)

## Versions

- `yabai`: `yabai-v7.1.16`
- `skhd`: `skhd-v0.3.9`
- `sketchybar`: `sketchybar-v2.23.0`
- `borders`: `borders-v1.8.4`

## Config locations

- `~/.yabairc`
- `~/.skhdrc`
- SketchyBar config: `~/.config/sketchybar/sketchybarrc`
- SketchyBar scripts: `~/.config/sketchybar/scripts/*.sh`
- Borders config: `~/.config/borders/bordersrc`
- launchd jobs (user): `~/Library/LaunchAgents/`

App bundles (created so macOS privacy UI actually lists them):

- `~/Applications/Yabai.app`
- `~/Applications/Skhd.app`
- `~/Applications/Borders.app`

Build/refresh them from this repo (copies binaries from PATH and ad-hoc signs):

- `scripts/build-app-bundles.sh`

## Service control

### The quick “reset everything”

From your terminal:

- `launchctl kickstart -k gui/$(id -u)/com.koekeishiya.yabai`
- `launchctl kickstart -k gui/$(id -u)/com.koekeishiya.skhd`
- `launchctl kickstart -k gui/$(id -u)/homebrew.mxcl.borders`
- `launchctl kickstart -k gui/$(id -u)/homebrew.mxcl.sketchybar`

(Your `Hyper + Escape` hotkey runs the same style of restart.)

### yabai

- Start: `yabai --start-service`
- Restart: `yabai --restart-service`
- Stop: `yabai --stop-service`
- Verify: `yabai -m query --displays`
- Logs: `/tmp/yabai_${USER}.err.log` and `/tmp/yabai_${USER}.out.log`

### skhd

- Restart service: `skhd --restart-service`
- Reload config: `skhd --reload`
- Logs: `/tmp/skhd_${USER}.err.log` and `/tmp/skhd_${USER}.out.log`

### SketchyBar

- Reload: `sketchybar --reload`
- Query bar: `sketchybar --query bar`

### Borders

- Restart: `brew services restart felixkratz/formulae/borders`
- Logs: `/opt/homebrew/var/log/borders/borders.err.log` and `/opt/homebrew/var/log/borders/borders.out.log`

## Permissions

System Settings → Privacy & Security:

- **Accessibility**: allow `Skhd.app`, `Yabai.app`, `Borders.app`
- **Input Monitoring**: allow `Karabiner-Elements` and `Skhd.app`
- **Screen Recording**: allow `Yabai.app` (required for some yabai config/features)

If hotkeys “randomly stop working” inside a terminal app:

- Disable **Secure Keyboard Entry** in that terminal (Terminal.app / iTerm2 commonly expose it).

## Spaces + scripting addition (SA)

Space switching and most space-level operations require the scripting addition.

Quick checks:

- `nvram boot-args` should include `-arm64e_preview_abi`
- `yabai -m space --focus 2` should succeed (if Space 2 exists)

Manual load (if needed):

- `sudo /Users/kell/Applications/Yabai.app/Contents/MacOS/yabai --load-sa`
- `yabai --restart-service`

Notes:

- Space hotkeys only work for Spaces that exist (e.g. if you only have 2 spaces, `Hyper+3` can’t work).
- Create more spaces via Mission Control.

## Keybinds (skhd)

Config file: `~/.skhdrc`

**Hyper** = `ctrl + alt + cmd + shift` (Caps Lock via Karabiner-Elements)

If `Cmd+Shift+9` works but `Hyper+9` doesn’t, enable **Input Monitoring** for `Karabiner-Elements`.

### Global keys

| Key | Action |
|---|---|
| `Hyper + Space` | Raycast search |
| `Hyper + Return` | Launch Ghostty |
| `Hyper + Escape` | Restart `yabai` + `skhd` + `borders`, reload SketchyBar |
| `Hyper + 9` | Touch `/tmp/skhd_hotkey_ok` (debug) |
| `Hyper + b` | Toggle SketchyBar hidden/shown |
| `Hyper + u` | Toggle *real* macOS menu bar (sets `yabai menubar_opacity` and hides/shows SketchyBar) |

### Focus + space

| Key | Action |
|---|---|
| `Hyper + h/j/k/l` | Focus window west/south/north/east |
| `Hyper + 1..5` | Focus Space 1..5 |

### Toggles

| Key | Action |
|---|---|
| `Hyper + t` | Toggle float |
| `Hyper + f` | Toggle zoom-fullscreen |
| `Hyper + z` | Toggle zoom-parent |
| `Hyper + q` | Close focused window |

### Modes (modal layers)

All modes exit with: `Space`, `Esc`, `Return`, the mode key again, or `Hyper+Esc`.

#### Resize mode

Enter: `Hyper + r`

- Small steps (20px):
  - `h` shrink width
  - `l` grow width
  - `k` shrink height
  - `j` grow height
  - `a/d` resize from left edge
  - `w/s` resize from top edge
- Big steps (80px): hold `Shift` with the resize keys
- Reset proportions: `b` → `yabai -m space --balance`

#### Swap mode

Enter: `Hyper + s`

- `h/j/k/l` swaps windows west/south/north/east

#### Warp mode (re-insert)

Enter: `Hyper + g`

- `h/j/k/l` warps the focused window west/south/north/east

#### Send-to-space mode

Enter: `Hyper + 0`

- `1..5` sends focused window to Space N and follows focus

#### Move floating mode

Enter: `Hyper + m`

- `h/j/k/l` nudges floating window by 40px

### Ghostty

- `Cmd + t` in Ghostty also triggers: `sleep 0.15; yabai -m space --balance`

## Menu bar + app menus

This setup intentionally hides the real macOS menu bar (`yabai` sets `menubar_opacity` to `0.0`).

To access app menus like “Preferences / Edit / View …”:

- Keyboard-first: `Ctrl+F2` (sometimes `fn+Ctrl+F2`) to focus the menu bar, then arrow keys.
- Direct prefs: most apps use `Cmd + ,`.
- Mouse/click: press `Hyper + u` (shows the menu bar and hides SketchyBar), then move the mouse to the top.

## Window management (yabai)

Useful queries:

- `yabai -m query --windows`
- `yabai -m query --windows --window`
- `yabai -m query --spaces`

Tree/layout commands:

- Balance: `yabai -m space --balance`
- Mirror: `yabai -m space --mirror x-axis` and `yabai -m space --mirror y-axis`
- Rotate: `yabai -m space --rotate 90` (also `180`, `270`)
- Layout: `yabai -m space --layout bsp` or `yabai -m space --layout float`

Notes on resizing in BSP:

- Some edges can’t be resized because there’s no fence on that side.
- If you see `cannot locate a bsp node fence.`, resize using the opposite edge or hit `b` in resize mode to rebalance.

## SketchyBar stats

Scripts (all in `~/.config/sketchybar/scripts/`):

- CPU: `cpu.sh` uses `top` “user+sys” so it stays 0–100% (no multi-core >100% spikes)
- Memory: `memory.sh` uses `active+wired+compressed` and detects VM page size
- Wi‑Fi: `wifi.sh` detects the Wi‑Fi device via `networksetup`, reads SSID via `airport -I`, and uses IP presence as online signal

Reload after changes:

- `sketchybar --reload`

## Karabiner rules

Karabiner-Elements is the default way this setup creates a Hyper key.

Bundles (from this repo):

- **Default**: **Caps Lock → Hyper (⌃⌥⌘⇧), Escape if tapped** (`capslock_hyper.json`).
- **Optional**: **Hyper + WASD → arrows** (`hyper_wasd_arrows.json`).
  - Implication: conflicts with `skhd` swap-mode default (`Hyper + s`). The installer script moves swap mode to `Hyper + e`.
- **Optional**: **Disable broken Right Arrow** (`disable_right_arrow.json`).
  - Implication: the physical Right Arrow key stops working everywhere (by design). If you also enable WASD arrows, you still have Right Arrow via `Hyper + d`.

Install helpers:

- `scripts/karabiner-install-hyper.sh` (base Hyper mapping)
- `scripts/karabiner-install-wasd-arrows.sh` (WASD arrows + patches `~/.skhdrc` swap mode to `Hyper + e`)
- `scripts/karabiner-install-disable-right-arrow.sh` (disable Right Arrow)

Enable in UI:

- Karabiner-Elements → **Complex Modifications** → **Add rule** → enable the rules you installed.

## Troubleshooting

### Space switching doesn’t work

- Confirm SA works: `yabai -m space --focus 2`
- If it errors with “scripting-addition”: `sudo /Users/kell/Applications/Yabai.app/Contents/MacOS/yabai --load-sa` then `yabai --restart-service`
- Make sure the target Space exists (Mission Control).

### CPU/memory/wifi values look wrong

- Reload SketchyBar: `sketchybar --reload`
- Check scripts:
  - `~/.config/sketchybar/scripts/cpu.sh`
  - `~/.config/sketchybar/scripts/memory.sh`
  - `~/.config/sketchybar/scripts/wifi.sh`

### Hotkeys stop working

- Check skhd log: `tail -n 50 /tmp/skhd_${USER}.err.log`
- Ensure Input Monitoring is enabled for `Karabiner-Elements` and `Skhd.app`
- Disable Secure Keyboard Entry in the terminal app you’re using

### Menu bar is “gone”

- It’s intentionally hidden: `yabai -m config menubar_opacity` likely returns `0.0000`.
- Toggle it via `Hyper + u`.
