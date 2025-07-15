#!/bin/bash

# Launch script for Clipboard Manager
cd "$(dirname "$0")"

# Ensure the executable has the right permissions
chmod +x ClipboardManager

# Launch the app
echo "Starting Clipboard Manager..."
echo "Look for the clipboard icon in your menu bar!"
echo "Press Ctrl+C to stop the application"

./ClipboardManager