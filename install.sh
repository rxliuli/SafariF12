#!/bin/bash
set -euo pipefail

APP_NAME="SafariF12"
INSTALL_DIR="$HOME/Applications"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_NAME="com.local.safarif12.plist"
CURRENT_USER=$(whoami)

REPO_RAW_BASE="https://raw.githubusercontent.com/rxliuli/SafariF12/main"

echo "🔧 SafariF12 Installer"
echo "======================"
echo ""

# ── Step 0: Check for Xcode command line tools ──
if ! xcode-select -p &>/dev/null; then
    echo "❌ Xcode Command Line Tools not found."
    echo "   Run: xcode-select --install"
    exit 1
fi

# ── Step 1: Get source files ──
WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

echo "⏳ Downloading source files..."
curl -fsSL "$REPO_RAW_BASE/$APP_NAME.swift" -o "$WORK_DIR/$APP_NAME.swift"
curl -fsSL "$REPO_RAW_BASE/$PLIST_NAME" -o "$WORK_DIR/$PLIST_NAME"
echo "✅ Downloaded."

# ── Step 2: Compile ──
echo "⏳ Compiling $APP_NAME..."
swiftc "$WORK_DIR/$APP_NAME.swift" \
    -o "$WORK_DIR/$APP_NAME" \
    -framework Cocoa \
    -framework Carbon \
    -O
echo "✅ Compiled successfully."

# ── Step 3: Install binary ──
mkdir -p "$INSTALL_DIR"
cp "$WORK_DIR/$APP_NAME" "$INSTALL_DIR/$APP_NAME"
chmod +x "$INSTALL_DIR/$APP_NAME"
echo "✅ Installed to $INSTALL_DIR/$APP_NAME"

# ── Step 4: Unload old agent if exists ──
if launchctl list "$PLIST_NAME" &>/dev/null 2>&1; then
    echo "⏳ Unloading existing LaunchAgent..."
    launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null || true
fi

# ── Step 5: Install LaunchAgent ──
mkdir -p "$LAUNCH_AGENTS_DIR"
sed "s/__USER__/$CURRENT_USER/g" "$WORK_DIR/$PLIST_NAME" > "$LAUNCH_AGENTS_DIR/$PLIST_NAME"
echo "✅ LaunchAgent installed to $LAUNCH_AGENTS_DIR/$PLIST_NAME"

# ── Step 6: Load and start ──
launchctl load "$LAUNCH_AGENTS_DIR/$PLIST_NAME"
echo "✅ LaunchAgent loaded."

echo ""
echo "🎉 Done! SafariF12 is now running."
echo ""
echo "📌 Important: First run will prompt for Accessibility permission."
echo "   Go to: System Settings → Privacy & Security → Accessibility"
echo "   Find and enable '$APP_NAME', then it will work automatically."
echo ""
echo "📌 Prerequisite: In Safari → Settings → Advanced,"
echo "   enable 'Show features for web developers'."
echo ""
echo "── Commands ──"
echo "  Stop:      launchctl unload ~/Library/LaunchAgents/$PLIST_NAME"
echo "  Start:     launchctl load ~/Library/LaunchAgents/$PLIST_NAME"
echo "  Uninstall: curl -fsSL https://raw.githubusercontent.com/rxliuli/SafariF12/main/uninstall.sh | bash"
echo "             or manually:"
echo "             launchctl unload ~/Library/LaunchAgents/$PLIST_NAME"
echo "             rm ~/Library/LaunchAgents/$PLIST_NAME"
echo "             rm ~/Applications/$APP_NAME"
