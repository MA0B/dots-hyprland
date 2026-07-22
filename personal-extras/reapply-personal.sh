#!/usr/bin/env bash
# Re-apply the personal layer onto the LIVE ~/.config after an upstream
# dots-hyprland update has overwritten it (e.g. end-4's own update flow).
# Does NOT touch /etc or packages (updates don't either) and never reverts
# upstream files to old versions:
#   - files that are entirely ours are copied whole from the repo;
#   - personal edits to upstream files are applied as patches on top of
#     whatever version is now live — if upstream changed the region, the
#     patch fails LOUDLY and tells you what to port by hand.
# Idempotent: already-applied patches are detected and skipped.
set -uo pipefail
cd "$(dirname "$0")"
DOTS=../dots/.config
CFG="$HOME/.config"

echo "==> Copying personal files (whole, always safe)"
own_files=(
    quickshell/ii/modules/ii/bar/BudsBattery.qml
    quickshell/ii/modules/ii/bar/ControllerBattery.qml
    quickshell/ii/modules/ii/verticalBar/BudsBattery.qml
    quickshell/ii/modules/ii/verticalBar/ControllerBattery.qml
    hypr/custom/env.lua
    hypr/custom/general.lua
    hypr/custom/keybinds.lua
    hypr/custom/scripts/hdr-toggle.sh
    chrome-flags.conf
)
for f in "${own_files[@]}"; do
    install -Dm"$([[ $f == *.sh ]] && echo 755 || echo 644)" "$DOTS/$f" "$CFG/$f"
done

echo "==> Patching personal edits into upstream files"
failed=()
for p in patches/*.patch; do
    name=$(basename "$p" .patch | sed 's|__|/|g')
    if patch -R -p1 -d "$CFG" --dry-run -f < "$p" >/dev/null 2>&1; then
        echo "   ok (already applied): $name"
    elif patch -p1 -d "$CFG" --dry-run -f < "$p" >/dev/null 2>&1; then
        patch -p1 -d "$CFG" -f --no-backup-if-mismatch < "$p" >/dev/null
        echo "   applied: $name"
    else
        echo "   FAILED: $name"
        failed+=("$name")
    fi
done

echo "==> Reloading Hyprland"
hyprctl reload >/dev/null 2>&1 || true   # quickshell auto-reloads on file change

if ((${#failed[@]})); then
    echo
    echo "!! Upstream changed these files too much for the patch to apply:"
    printf '   %s\n' "${failed[@]}"
    echo "Port those edits by hand (see personal-extras/patches/*.patch for"
    echo "what they contain), then run ./regen-patches.sh and commit."
    exit 1
fi

echo
echo "Done. When everything looks right, sync live -> repo as usual"
echo "(copy changed dots + ./capture-system.sh) and commit."
