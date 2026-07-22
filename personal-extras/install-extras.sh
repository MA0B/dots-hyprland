#!/usr/bin/env bash
# Personal extras on top of dots-hyprland: fixes ç/Ç (Brazilian cedilla,
# apostrophe convention) to work identically in every app, including
# Chromium/Electron apps like Discord, via fcitx5 as the system input method.
#
# "./setup install" from the repo root runs this automatically (after
# restore-system.sh); it can also be run standalone.
# This script uses sudo interactively — run it yourself, don't pipe a
# password into it.
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Installing fcitx5"
sudo pacman -S --needed fcitx5

echo "==> Installing ~/.XCompose (dead_acute + c/C => ç/Ç directly)"
install -m644 XCompose "$HOME/.XCompose"

echo "==> Installing LG 27GN750 ICC profile (used by the SDR mode of the HDR toggle)"
install -Dm644 icc/27GN7.icm "$HOME/.local/share/icc/27GN7.icm"

echo
echo "Done. fcitx5 is started by ~/.config/hypr/custom/execs.lua (installed"
echo "normally by './setup install') and QT_IM_MODULE/XMODIFIERS are set to"
echo "fcitx by ~/.config/hypr/custom/env.lua (same install step)."
echo
echo "Log out/in once so the systemd --user session picks up those env vars."
echo "The default input method (keyboard-us-intl) is configured via"
echo "~/.config/fcitx5/profile, created interactively the first time fcitx5"
echo "runs (fcitx5-configtool) — set Layout=us, Default Input Method=keyboard-us-intl"
echo "if it doesn't pick that automatically."
echo
echo "Test: ' + c => ç, ' + C => Ç, in every app including Discord/Chromium."
