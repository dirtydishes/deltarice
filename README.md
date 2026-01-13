# deltarice

My personal macOS “rice” setup, managed with **GNU Stow**.

This repo is structured so you can run one `stow` command and get:

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

## Notes

- If `stow` complains about conflicts, you likely already have a real file where the symlink wants to go. Move it out of the way first.
- Some configs may include machine-specific paths. Search for your username and update as needed:

```sh
rg -n "(/Users/kell|kell)" stow
```

## Reference

See `macos-rice-cheatsheet.md` for keybinds, service control, and permissions setup (Accessibility/Input Monitoring/Screen Recording, scripting addition notes, etc.).
