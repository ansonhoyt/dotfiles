#!/bin/bash
# Logi Options+ multi-user switcher.
#
# Triggered by launchd on Fast User Switching events
# (notify key: com.apple.system.loginwindow.fus).
# Ensures only the foreground GUI user runs the Logi Options+ agent,
# so two agents don't race for HID exclusivity over the MX Master 4.
#
# Real launchd Label is com.logi.cp-dev-mgr (filename
# /Library/LaunchAgents/com.logi.optionsplus.plist is misleading).

set -u

PLIST=/Library/LaunchAgents/com.logi.optionsplus.plist
LABEL=com.logi.cp-dev-mgr

ACTIVE_UID=$(stat -f %u /dev/console)
TS=$(date -u +%FT%TZ)

for user in $(who | awk '/console/ { print $1 }' | sort -u); do
    uid=$(id -u "$user" 2>/dev/null) || continue
    if [ "$uid" = "$ACTIVE_UID" ]; then
        launchctl enable "gui/$uid/$LABEL" 2>/dev/null || true
        launchctl bootstrap "gui/$uid" "$PLIST" 2>/dev/null || true
        launchctl kickstart -k "gui/$uid/$LABEL" 2>/dev/null || true
        echo "$TS activated $user (uid=$uid)"
    else
        launchctl bootout "gui/$uid/$LABEL" 2>/dev/null || true
        echo "$TS suspended $user (uid=$uid)"
    fi
done
