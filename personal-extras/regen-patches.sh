#!/usr/bin/env bash
# Regenerate patches/ from git: the personal edits made to files that ALSO
# exist upstream (everything else is additive and lives as whole files).
# Run after re-syncing dots/.config or after merging upstream, so
# reapply-personal.sh always carries fresh patches. Requires upstream fetched
# (git fetch upstream).
set -euo pipefail
cd "$(dirname "$0")/.."

base=$(git merge-base main upstream/main)
echo "==> Diff base: $(git log -1 --format='%h %s' "$base")"

# Upstream files carrying personal edits (paths relative to dots/.config)
patched_files=(
    quickshell/ii/modules/ii/bar/BarContent.qml
    quickshell/ii/modules/ii/verticalBar/VerticalBarContent.qml
    quickshell/ii/services/AppSearch.qml
    quickshell/ii/services/Idle.qml
    hypr/hyprland/env.lua
    hypr/hyprland/general.lua
    hypr/hypridle.conf
)

mkdir -p personal-extras/patches
rm -f personal-extras/patches/*.patch
for f in "${patched_files[@]}"; do
    out="personal-extras/patches/$(echo "$f" | sed 's|/|__|g').patch"
    git diff --relative=dots/.config "$base" main -- "dots/.config/$f" > "$out"
    [[ -s "$out" ]] || { echo "WARNING: empty diff for $f (edit gone?)"; rm "$out"; }
done
ls -1 personal-extras/patches/
echo "Done. Commit the regenerated patches."
