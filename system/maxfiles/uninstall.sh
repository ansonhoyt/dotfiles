#!/usr/bin/env bash
# Uninstall limit.maxfiles LaunchDaemon. Reverts to launchd default (256)
# on next reboot.

set -e

PLIST_DST=/Library/LaunchDaemons/limit.maxfiles.plist

echo "Removing limit.maxfiles..."
sudo launchctl bootout system/limit.maxfiles 2>/dev/null || true
sudo rm -f "$PLIST_DST"

echo ""
echo "✓ limit.maxfiles removed (default restored after reboot)"
