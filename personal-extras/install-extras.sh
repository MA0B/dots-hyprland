#!/usr/bin/env bash
# Personal extras on top of dots-hyprland: fixes ç/Ç (Brazilian cedilla,
# apostrophe convention) to work identically in every app, including
# Chromium/Electron apps like Discord, which ignore ~/.XCompose.
#
# Run this AFTER "./setup install" from the repo root.
# This script uses sudo interactively — run it yourself, don't pipe a
# password into it.
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Installing keyd"
sudo pacman -S --needed keyd

echo "==> Installing custom XKB layout (ccedilla direct mapping, bypasses app-side compose)"
sudo install -Dm644 xkb-symbols-brintl /usr/share/X11/xkb/symbols/brintl

echo "==> Installing keyd config (hold ' >=100ms + c => ç, + Shift+c => Ç)"
sudo install -Dm644 keyd-default.conf /etc/keyd/default.conf

echo "==> Enabling keyd"
sudo systemctl enable --now keyd
sudo systemctl restart keyd

echo "==> Installing ~/.XCompose (fallback for GTK/Qt apps that do read Compose files)"
install -m644 XCompose "$HOME/.XCompose"

echo "==> Reloading Hyprland (requires ~/.config/hypr/custom/general.lua from this repo,"
echo "    copied there by './setup install' — kb_layout=brintl kb_variant=basic)"
if command -v hyprctl &>/dev/null && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  hyprctl reload
else
  echo "    (not running inside Hyprland right now, skipping reload)"
fi

echo
echo "Done. Test: hold ' (~100ms) and tap c => should type 'ç'. Quick/rollover ' + vowel => normal accent, no misfire."
echo "Note: after a fresh install, log out/in once so the systemd --user session"
echo "picks up a clean environment (no stray GTK_IM_MODULE/QT_IM_MODULE overrides)."
