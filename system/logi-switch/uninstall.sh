#!/usr/bin/env bash
# Uninstall logi-switch: stop the daemon and remove its files.

set -e

PLIST_DST=/Library/LaunchDaemons/com.local.logi-switch.plist
HELPER_DST=/usr/local/sbin/logi-switch

echo "Unloading launchd job..."
sudo launchctl bootout system/com.local.logi-switch 2>/dev/null || true

echo "Removing files..."
sudo rm -f "$PLIST_DST" "$HELPER_DST"

echo ""
echo "✓ logi-switch removed"
echo "  Note: Logi Options+ agents will race again under Fast User Switching."
echo "  To suppress one user's agent: sudo launchctl disable gui/<uid>/com.logi.cp-dev-mgr"
