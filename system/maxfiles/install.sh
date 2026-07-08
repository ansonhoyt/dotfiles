#!/usr/bin/env bash
# Install limit.maxfiles: a root LaunchDaemon that raises the system-wide
# open-files limit at boot.
#
# Why: bash sets `ulimit -n 65536` (.bash/env.sh), but that only reaches
# processes spawned from a shell. GUI apps launched by launchd — Ghostty and
# anything from Spotlight/Dock — inherit launchd's `maxfiles` (default 256).
# 256 FDs surfaces as silent hangs (kitty-graphics fan-out, watchers, esbuild)
# rather than EMFILE errors. This sets soft 65536 / hard 524288 for everyone.
#
# Verify (launchctl limit reads launchd's live global config — same in any
# shell, old or new, immediately):
#   launchctl limit maxfiles   # -> soft 65536  (hard 'unlimited',
#                              #     bounded by kern.maxfilesperproc)
# Only the soft default moves (256 -> 65536); hard was already unlimited.
# An ALREADY-running GUI app keeps the ceiling it inherited at launch — quit
# & reopen it (or reboot) for the new soft limit to take effect there.

set -e

SRC="$(cd "$(dirname "$0")" && pwd)"
PLIST_DST=/Library/LaunchDaemons/limit.maxfiles.plist

echo "Installing limit.maxfiles..."
sudo install -m 0644 -o root -g wheel "$SRC/limit.maxfiles.plist" "$PLIST_DST"

echo "Reloading launchd..."
sudo launchctl bootout system/limit.maxfiles 2>/dev/null || true
sudo launchctl bootstrap system "$PLIST_DST"

echo "Applying now (also active immediately, no reboot needed)..."
sudo launchctl limit maxfiles 65536 524288

echo ""
echo "✓ limit.maxfiles installed"
echo "  Check: launchctl limit maxfiles   (expect soft 65536; hard 'unlimited')"
echo "  GUI apps pick it up on next launch; full effect after reboot."
echo "  Uninstall: ./system/maxfiles/uninstall.sh"
