#!/usr/bin/env bash
# Re-snapshot the live system into this repo (the inverse of restore-system.sh).
# Run before committing whenever /etc tweaks, package sets or the files below
# changed on the live machine. No sudo needed — everything read is world-readable.
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Package lists"
pacman -Qqen | sort > packages/pacman.txt
pacman -Qqm | grep -v -- '-debug$' | sort > packages/aur.txt
flatpak list --app --columns=application > packages/flatpak.txt

echo "==> /etc snapshot"
cp /etc/environment                                 system/etc/
cp /etc/modprobe.d/btusb-no-autosuspend.conf        system/etc/modprobe.d/
cp /etc/systemd/network/50-wol.link                 system/etc/systemd/network/
cp /etc/systemd/network/20-wired.network            system/etc/systemd/network/
cp /etc/systemd/zram-generator.conf                 system/etc/systemd/
cp /etc/xdg/reflector/reflector.conf                system/etc/xdg/reflector/
cp /etc/systemd/system/getty@tty1.service.d/autologin.conf \
                                                    system/etc/systemd/system/getty@tty1.service.d/

echo "==> \$HOME snapshot"
cp ~/.bash_profile                                  home/
cp ~/.config/systemd/user/g733-leds-off.service     home/.config/systemd/user/
cp ~/.config/systemd/user/g733-leds-off.timer       home/.config/systemd/user/
cp ~/.config/fcitx5/profile                         home/.config/fcitx5/
cp ~/.XCompose                                      XCompose
cp ~/.local/share/icc/27GN7.icm                     icc/

echo
echo "Done. Review with 'git status' / 'git diff' in the repo root, then commit."
echo "(The dots/.config tree is synced separately — copy changed live files in"
echo "by hand, as usual.)"
