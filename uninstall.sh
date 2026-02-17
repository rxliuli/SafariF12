#!/bin/bash
set -euo pipefail

APP_NAME="SafariF12"
PLIST_NAME="com.local.safarif12.plist"

echo "🗑  SafariF12 Uninstaller"
echo "========================"
echo ""

# Stop the agent
if launchctl list | grep -q "com.local.safarif12"; then
    echo "⏳ Stopping SafariF12..."
    launchctl unload "$HOME/Library/LaunchAgents/$PLIST_NAME" 2>/dev/null || true
    echo "✅ Stopped."
fi

# Remove files
rm -f "$HOME/Library/LaunchAgents/$PLIST_NAME" && echo "✅ Removed LaunchAgent."
rm -f "$HOME/Applications/$APP_NAME" && echo "✅ Removed binary."

echo ""
echo "🎉 SafariF12 has been completely uninstalled."
