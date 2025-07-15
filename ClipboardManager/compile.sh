#!/bin/bash

# Compile and run the Clipboard Manager
swiftc -o ClipboardManager main.swift -framework Cocoa -framework Foundation

# Make it executable
chmod +x ClipboardManager

echo "Clipboard Manager compiled successfully!"
echo "Run './ClipboardManager' to start the application"