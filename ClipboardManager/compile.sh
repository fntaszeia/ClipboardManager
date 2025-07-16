#!/bin/bash

# Compile and run the Clipboard Manager
swiftc -o ClipboardManager main.swift -framework Cocoa -framework Foundation

# Make it executable
chmod +x ClipboardManager

# Copy executable to app bundle
cp ClipboardManager ClipboardManager.app/Contents/MacOS/

# Copy icon if it exists
if [ -f ClipboardManager.icns ]; then
    cp ClipboardManager.icns ClipboardManager.app/Contents/Resources/
fi

echo "Clipboard Manager compiled successfully!"
echo "Run './ClipboardManager' to start the application"
echo "Or run the app bundle: open ClipboardManager.app"