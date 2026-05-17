#!/bin/bash
# Logi Options+ multi-user switcher.
#
# Run by launchd every 15s (StartInterval). macOS 26 doesn't post any
# BSD-notify-style notification on Fast User Switching that LaunchEvents
# could hook (verified empirically — watched all loginwindow.* keys plus
# fastUserSwitchBegin/End, console_user, sessionAgent.* — none fired on
# real FUS). Polling is the only reliable trigger; the state-file gate
# below keeps the cost to one stat + one cat when nothing changed.
# Ensures only the foreground GUI user runs the Logi Options+ agent,
# so two agents don't race for HID exclusivity over the MX Master 4.
#
# Real launchd Label is com.logi.cp-dev-mgr (filename
# /Library/LaunchAgents/com.logi.optionsplus.plist is misleading).

set -u

PLIST=/Library/LaunchAgents/com.logi.optionsplus.plist
LABEL=com.logi.cp-dev-mgr
STATE=/var/run/logi-switch.active-uid

ACTIVE_UID=$(stat -f %u /dev/console)
TS=$(date -u +%FT%TZ)

# Skip if the active console user hasn't changed since last tick.
PREV_UID=$(cat "$STATE" 2>/dev/null || true)
if [ "$ACTIVE_UID" = "$PREV_UID" ]; then
    exit 0
fi
echo "$ACTIVE_UID" > "$STATE"

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
