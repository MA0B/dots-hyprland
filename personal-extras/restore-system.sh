#!/usr/bin/env bash
# Restore system-level state on a fresh Arch install (the inverse of
# capture-system.sh). Run AFTER "./setup install" from the repo root, as the
# normal user. Uses sudo interactively — run it yourself, don't pipe a
# password into it. Idempotent: safe to re-run.
#
# Assumes: same username (morrice — getty autologin and .bash_profile hardcode
# it), Arch with systemd. See README.md for the manual steps this does NOT
# cover (bootloader/NVIDIA kernel params, fstab, Wi-Fi, logins).
set -euo pipefail
cd "$(dirname "$0")"

echo "==> pacman.conf: Color + ParallelDownloads + multilib (steam/lib32)"
sudo sed -i 's/^#Color$/Color/; s/^#ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf
sudo sed -i '/^#\[multilib\]$/{s/^#//;n;s/^#//}' /etc/pacman.conf
sudo pacman -Sy

echo "==> Official packages"
sudo pacman -S --needed - < packages/pacman.txt

if ! command -v yay >/dev/null; then
    echo "==> Bootstrapping yay"
    tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
    (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$tmp"
fi

echo "==> AUR packages"
yay -S --needed - < packages/aur.txt

echo "==> Flatpak (user) packages"
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
xargs -r flatpak install --user -y flathub < packages/flatpak.txt

echo "==> /etc files (WoL, zram, reflector, modprobe, getty autologin)"
(cd system/etc && sudo cp -r --parents . /etc/)

echo "==> BlueZ: expose battery of BT devices (Galaxy Buds) over D-Bus"
sudo sed -i 's/^#Experimental = false/Experimental = true/' /etc/bluetooth/main.conf

echo "==> System services"
sudo systemctl enable systemd-networkd systemd-resolved iwd bluetooth
sudo systemctl enable reflector.timer paccache.timer fstrim.timer btrfs-scrub@-.timer
# Login is getty autologin on tty1 + exec start-hyprland in ~/.bash_profile,
# not a display manager:
sudo systemctl disable sddm 2>/dev/null || true

echo "==> \$HOME files (.bash_profile, G733 LED units, fcitx5 profile)"
cp -r home/. "$HOME"/
systemctl --user daemon-reload
systemctl --user enable g733-leds-off.timer ydotool.service

echo
echo "Done. Now run ./install-extras.sh (fcitx5 + XCompose + monitor ICC),"
echo "check the manual steps in README.md, and reboot."
