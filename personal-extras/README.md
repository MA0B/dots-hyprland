# Personal extras (Mauricio)

Additions on top of upstream dots-hyprland that don't fit in `~/.config`
(they touch `/etc` and `/usr/share`, which the main installer doesn't manage):

- **keyd-default.conf** → `/etc/keyd/default.conf`
- **xkb-symbols-brintl** → `/usr/share/X11/xkb/symbols/brintl`
- **XCompose** → `~/.XCompose`

Together these make `ç`/`Ç` (hold `'` for ~100ms + `c`/`Shift+c`) work
identically in every app, including Chromium/Electron apps (Discord, etc.)
which ignore `~/.XCompose`. Normal accents (á é í ó ú ã õ ñ — quick tap of
`'`) already work everywhere via plain Hyprland/XKB
(`kb_layout=brintl kb_variant=basic`, set in
`../dots/.config/hypr/custom/general.lua`, installed normally by
`./setup install`).

`'` is bound to `overloadt2(cedil, apostrophe, 100)` in keyd: it only
commits to the cedilla layer if held for >=100ms, so fast/rollover typing
(where the next key is struck slightly before `'` is released) still
resolves as a normal apostrophe/dead-key instead of misfiring into the
cedilla layer. Adjust the `100` in `keyd-default.conf` if that threshold
ever feels off.

## Fresh install on a new machine

```bash
./setup install              # from the repo root — installs dots-hyprland itself
./personal-extras/install-extras.sh   # this folder — installs keyd + XKB + XCompose
```

Then log out/in once.
