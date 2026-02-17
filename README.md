# SafariF12

Press **F12** in Safari to toggle Web Inspector, just like Chrome.

Lightweight, no UI, no Dock icon. Only intercepts F12 when Safari is the active app — all other apps are unaffected.

## One-liner Install

```bash
git clone https://github.com/rxliuli/SafariF12.git && cd SafariF12 && bash install.sh
```

This will:
1. Compile the Swift source locally (no pre-built binary, no signing needed)
2. Install to `~/Applications/SafariF12`
3. Create a LaunchAgent for auto-start on login
4. Start the service immediately

### Prerequisites

- **Xcode Command Line Tools** — `xcode-select --install`
- **Safari** → Settings → Advanced → Enable **"Show features for web developers"**
- First run: grant **Accessibility** permission in System Settings → Privacy & Security → Accessibility

## Uninstall

```bash
cd SafariF12 && bash uninstall.sh
```

## How it works

A `CGEvent` tap listens for F12 keydown events. When Safari is frontmost, it swallows F12 and posts **⌥⌘I** (the native Web Inspector toggle). Zero overhead when Safari is not in focus.

## Files

| File | Purpose |
|------|---------|
| `SafariF12.swift` | Source code |
| `install.sh` | Build & install |
| `uninstall.sh` | Clean removal |
| `com.local.safarif12.plist` | LaunchAgent template |
