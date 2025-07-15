#!/bin/bash

# Kill any existing instances
killall ClipboardManager 2>/dev/null || true

# Compile the app
./compile.sh

# Copy to app bundle
cp ClipboardManager ClipboardManager.app/Contents/MacOS/

# Launch the app
echo "Launching Clipboard Manager..."
echo "Look for 📋 in your menu bar!"
open ClipboardManager.app

# Give it a moment to start
sleep 2

# Check if it's running
if pgrep ClipboardManager > /dev/null; then
    echo "✅ ClipboardManager is running!"
    echo "📋 Click the clipboard icon in your menu bar to access clipboard history"
else
    echo "❌ ClipboardManager failed to start"
fi