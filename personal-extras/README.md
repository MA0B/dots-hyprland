# Personal extras (Mauricio)

Additions on top of upstream dots-hyprland that don't fit in `~/.config`
(this one touches `$HOME` directly, outside anything the main installer
manages):

- **XCompose** → `~/.XCompose`

This makes `ç`/`Ç` (`'` + `c`/`Shift+c`, no hold needed) work identically
in every app, including Chromium/Electron apps (Discord, etc.), via
**fcitx5** as the system input method — Electron only honors IME
composition through ibus/fcitx, never a plain `~/.XCompose` file read
directly by the toolkit, which is why fcitx5 is in the loop at all instead
of just shipping a Compose file.

The rest of the wiring lives in the normal dots-hyprland tree, installed by
`./setup install` from the repo root:

- `../dots/.config/hypr/custom/general.lua` — `kb_layout=us kb_variant=intl`
  (normal accents: á é í ó ú ã õ ñ, quick tap of `'`)
- `../dots/.config/hypr/custom/execs.lua` — starts `fcitx5 -d` on Hyprland
  startup
- `../dots/.config/hypr/custom/env.lua` — sets `GTK_IM_MODULE`,
  `QT_IM_MODULE`, `XMODIFIERS` to `fcitx`, and `XCOMPOSEFILE` to
  `~/.XCompose`

fcitx5's own input-method selection (which layout/engine it uses,
`keyboard-us-intl`) lives in `~/.config/fcitx5/profile`, not tracked here —
it's regenerated interactively via `fcitx5-configtool` on first run.

## Fresh install on a new machine

```bash
./setup install              # from the repo root — installs dots-hyprland itself
./personal-extras/install-extras.sh   # this folder — installs fcitx5 + XCompose
```

Then log out/in once, and run `fcitx5-configtool` to set Layout=us /
Default Input Method=keyboard-us-intl if it isn't picked up automatically.
