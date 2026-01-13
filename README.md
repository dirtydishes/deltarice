# deltarice

My personal macOS “rice” setup.

**Choose your install style:**

- **Symlinks (Stow)**: use `stow/` packages (recommended)
- **Copy files**: use `dotfiles/` (mirrors `$HOME`)

**Start here:**

- [macos-rice-cheatsheet.md](macos-rice-cheatsheet.md) (permissions, services, keybinds)

**Downloads / Links:**

- Hyper key: [Hyperkey](https://hyperkey.app/) or [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
- Launcher: [Raycast](https://www.raycast.com/)
- Terminal: [Ghostty](https://ghostty.org/)
- Font: [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)
- WM + hotkeys: [yabai](https://github.com/koekeishiya/yabai), [skhd](https://github.com/koekeishiya/skhd)
- Menu bar: [SketchyBar](https://felixkratz.github.io/SketchyBar/)
- Borders: [JankyBorders](https://github.com/FelixKratz/JankyBorders)
- Shell: [Oh My Zsh](https://ohmyz.sh/), [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- Theme: [Catppuccin](https://catppuccin.com/) (Mocha + Lavender)

## The Rice

Catppuccin **Mocha** with **Lavender** accents across the stack.

- **Terminal (Ghostty)**: JetBrainsMono Nerd Font, Mocha palette, ~0.92 opacity + blur (`stow/ghostty/.config/ghostty/config`)
- **Menu bar (SketchyBar)**: translucent Mocha bar + lavender borders (`stow/sketchybar/.config/sketchybar/colors.sh`)
- **Borders**: rounded 6px border with lavender glow on focus (`stow/borders/.config/borders/bordersrc`)
- **Shell prompt**: Zsh + Powerlevel10k (`stow/zsh/.p10k.zsh`)
- **WM feel**: yabai animations enabled + eased, plus modal HUD feedback (`stow/yabai/.yabairc`, `stow/sketchybar/.config/sketchybar/scripts/mode_hud.sh`)

This repo is structured so you can get:

- Zsh + Powerlevel10k config
- Yabai + skhd (tiling + hotkeys)
- SketchyBar (menu bar)
- Borders (window borders)
- Ghostty config

## Layout

All managed files live under `stow/<package>/…` and are symlinked into `$HOME`.

Current packages:

- `stow/zsh` → `~/.zshrc`, `~/.zprofile`, `~/.zshenv`, `~/.profile`, `~/.p10k.zsh`, plus `~/.oh-my-zsh/custom/*` (no vendored theme repo)
- `stow/yabai` → `~/.yabairc`
- `stow/skhd` → `~/.skhdrc`
- `stow/borders` → `~/.config/borders/*`
- `stow/ghostty` → `~/.config/ghostty/*`
- `stow/sketchybar` → `~/.config/sketchybar/*`

## Prereqs

- Homebrew
- `stow`
- The apps/services you want to run (yabai, skhd, sketchybar, borders, ghostty)

Suggested installs:

```sh
brew install stow yabai skhd sketchybar borders
brew install --cask ghostty
```

### Oh My Zsh + Powerlevel10k

This repo tracks `~/.p10k.zsh` and `~/.oh-my-zsh/custom/*`, but it does **not** vendor the full Powerlevel10k theme repo.

Install Powerlevel10k into the standard Oh My Zsh location:

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ~/.oh-my-zsh/custom/themes/powerlevel10k
```

(Install Oh My Zsh however you prefer; this repo assumes it’s at `~/.oh-my-zsh`.)

## Install / Update

### Option A (recommended): symlinks via Stow

Dry-run first:

```sh
stow -n -v -d stow -t "$HOME" zsh yabai skhd borders ghostty sketchybar
```

Then apply:

```sh
stow -v -d stow -t "$HOME" zsh yabai skhd borders ghostty sketchybar
```

To remove symlinks later:

```sh
stow -D -v -d stow -t "$HOME" zsh yabai skhd borders ghostty sketchybar
```

### Option B: copy files (no symlinks)

If you prefer a plain “just files” layout, use `dotfiles/` (it mirrors `$HOME`):

- Copy everything:

```sh
rsync -a dotfiles/ "$HOME"/
```

- Or copy just one component, e.g. SketchyBar:

```sh
rsync -a dotfiles/.config/sketchybar/ "$HOME/.config/sketchybar"/
```

## Hotkeys

This setup expects a “Hyper key” on Caps Lock.

- `~/.skhdrc` binds Hyper as `ctrl + alt + cmd + shift`.
- Recommended: configure Hyperkey (or Karabiner) to map **Caps Lock → ctrl+alt+cmd+shift**.
- Quick sanity check: press `Hyper + 9` to create `/tmp/skhd_hotkey_ok` (fallback: `Cmd+Shift+9`). If the fallback works but Hyper doesn’t, enable **Input Monitoring** for `Hyperkey.app`.

## Permissions

System Settings → Privacy & Security:

- **Accessibility**: allow `Skhd.app`, `Yabai.app`, `Borders.app`, and `Hyperkey.app`
- **Input Monitoring**: allow `Skhd.app` (and `Hyperkey.app` if you use it)
- **Screen Recording**: allow `Yabai.app` (needed for window animations)

If hotkeys stop working inside a terminal:

- Disable **Secure Keyboard Entry** in that terminal app.

## Notes

- If `stow` complains about conflicts, you likely already have a real file where the symlink wants to go. Move it out of the way first.
- Animations + HUD: controlled by `yabai` (`window_animation_duration`, `window_animation_easing`) and SketchyBar’s `mode_hud` event.
- Some configs may include machine-specific paths. Search for your username and update as needed:

```sh
rg -n "(/Users/kell|kell)" stow
```

## Reference

See `macos-rice-cheatsheet.md` for keybinds, service control, and permissions setup (Accessibility/Input Monitoring/Screen Recording, scripting addition notes, etc.).
