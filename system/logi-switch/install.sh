#!/usr/bin/env bash
# Install logi-switch: a root LaunchDaemon that ensures only the foreground
# GUI user runs the Logi Options+ agent, fixing gestures / Action Ring loss
# under Fast User Switching.

set -e

SRC="$(cd "$(dirname "$0")" && pwd)"
PLIST_DST=/Library/LaunchDaemons/com.local.logi-switch.plist
HELPER_DST=/usr/local/sbin/logi-switch

echo "Installing logi-switch..."
sudo install -d -m 0755 -o root -g wheel /usr/local/sbin
sudo install -m 0755 -o root -g wheel "$SRC/logi-switch.sh" "$HELPER_DST"
sudo install -m 0644 -o root -g wheel "$SRC/com.local.logi-switch.plist" "$PLIST_DST"

echo "Re-enabling Logi Options+ agent for console users..."
for user in $(who | awk '/console/ { print $1 }' | sort -u); do
  uid=$(id -u "$user" 2>/dev/null) || continue
  sudo launchctl enable "gui/$uid/com.logi.cp-dev-mgr" 2>/dev/null || true
done

echo "Reloading launchd..."
sudo launchctl bootout system/com.local.logi-switch 2>/dev/null || true
sudo launchctl bootstrap system "$PLIST_DST"

echo "Applying current state..."
sudo "$HELPER_DST"

echo ""
echo "✓ logi-switch installed"
echo "  Logs: /var/log/logi-switch.log"
echo "  Uninstall: ./system/logi-switch/uninstall.sh"
