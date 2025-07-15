#!/bin/bash

# ClipboardManager Installer Script
# This script installs ClipboardManager and optionally sets up auto-startup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation directory
INSTALL_DIR="$HOME/Applications/ClipboardManager"
APP_NAME="ClipboardManager"

echo -e "${BLUE}📋 ClipboardManager Installer${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}❌ This application requires macOS${NC}"
    exit 1
fi

# Check macOS version
mac_version=$(sw_vers -productVersion | cut -d. -f1-2)
if [[ "$(echo "$mac_version < 10.15" | bc)" -eq 1 ]]; then
    echo -e "${RED}❌ macOS 10.15 (Catalina) or later required${NC}"
    echo -e "${RED}   Current version: $mac_version${NC}"
    exit 1
fi

echo -e "${GREEN}✅ macOS compatibility check passed${NC}"

# Check if Xcode command line tools are installed
if ! xcode-select -p &> /dev/null; then
    echo -e "${YELLOW}⚠️  Xcode command line tools not found${NC}"
    echo -e "${YELLOW}   Installing Xcode command line tools...${NC}"
    xcode-select --install
    echo -e "${YELLOW}   Please run this installer again after installation completes${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Xcode command line tools found${NC}"

# Create installation directory
echo -e "${BLUE}📁 Creating installation directory...${NC}"
mkdir -p "$INSTALL_DIR"

# Copy files to installation directory
echo -e "${BLUE}📋 Copying files...${NC}"
cp main.swift "$INSTALL_DIR/"
cp compile.sh "$INSTALL_DIR/"
cp run_app.sh "$INSTALL_DIR/"
cp launch.sh "$INSTALL_DIR/"
cp README.md "$INSTALL_DIR/"
cp .gitignore "$INSTALL_DIR/"

# Copy app bundle if it exists
if [[ -d "ClipboardManager.app" ]]; then
    cp -r ClipboardManager.app "$INSTALL_DIR/"
fi

# Copy executable if it exists
if [[ -f "ClipboardManager" ]]; then
    cp ClipboardManager "$INSTALL_DIR/"
fi

echo -e "${GREEN}✅ Files copied successfully${NC}"

# Make scripts executable
chmod +x "$INSTALL_DIR/compile.sh"
chmod +x "$INSTALL_DIR/run_app.sh"
chmod +x "$INSTALL_DIR/launch.sh"

# Compile the application
echo -e "${BLUE}🔨 Compiling ClipboardManager...${NC}"
cd "$INSTALL_DIR"
./compile.sh

if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✅ Compilation successful${NC}"
else
    echo -e "${RED}❌ Compilation failed${NC}"
    exit 1
fi

# Make the compiled executable... executable
chmod +x "$INSTALL_DIR/ClipboardManager"

# Update app bundle
echo -e "${BLUE}📦 Updating app bundle...${NC}"
mkdir -p "$INSTALL_DIR/ClipboardManager.app/Contents/MacOS"
cp "$INSTALL_DIR/ClipboardManager" "$INSTALL_DIR/ClipboardManager.app/Contents/MacOS/"

# Create symlink for easy access
echo -e "${BLUE}🔗 Creating symlink...${NC}"
mkdir -p "$HOME/bin"
ln -sf "$INSTALL_DIR/ClipboardManager" "$HOME/bin/clipboardmanager"

echo -e "${GREEN}✅ Installation completed successfully!${NC}"
echo ""

# Ask about auto-startup
echo -e "${YELLOW}🚀 Auto-Startup Configuration${NC}"
echo -e "${YELLOW}==============================${NC}"
echo ""
echo "Would you like ClipboardManager to start automatically when you log in?"
echo "This will add it to your Login Items."
echo ""
read -p "Enable auto-startup? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}⚙️  Setting up auto-startup...${NC}"
    
    # Create launch agent plist
    PLIST_PATH="$HOME/Library/LaunchAgents/com.clipboardmanager.plist"
    
    cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.clipboardmanager</string>
    <key>ProgramArguments</key>
    <array>
        <string>$INSTALL_DIR/ClipboardManager</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>LaunchOnlyOnce</key>
    <true/>
</dict>
</plist>
EOF

    # Load the launch agent
    launchctl load "$PLIST_PATH" 2>/dev/null || true
    
    echo -e "${GREEN}✅ Auto-startup configured successfully${NC}"
    echo -e "${GREEN}   ClipboardManager will start automatically on next login${NC}"
else
    echo -e "${YELLOW}⏭️  Auto-startup skipped${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Installation Complete!${NC}"
echo -e "${GREEN}========================${NC}"
echo ""
echo -e "${BLUE}📍 Installation Location:${NC} $INSTALL_DIR"
echo -e "${BLUE}🚀 To start manually:${NC} $INSTALL_DIR/ClipboardManager"
echo -e "${BLUE}📋 Or run from anywhere:${NC} clipboardmanager"
echo ""
echo -e "${YELLOW}Usage:${NC}"
echo "1. Look for the 📋 icon in your menu bar"
echo "2. Click it to see your clipboard history"
echo "3. Click any item to copy it to clipboard"
echo "4. Option+Click links to open them in browser"
echo ""

# Start the application
echo -e "${BLUE}🚀 Starting ClipboardManager...${NC}"
"$INSTALL_DIR/ClipboardManager" &

if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✅ ClipboardManager started successfully!${NC}"
    echo -e "${GREEN}   Look for the 📋 icon in your menu bar${NC}"
else
    echo -e "${RED}❌ Failed to start ClipboardManager${NC}"
    echo -e "${RED}   Try running manually: $INSTALL_DIR/ClipboardManager${NC}"
fi

echo ""
echo -e "${BLUE}📖 For help and documentation:${NC}"
echo -e "${BLUE}   https://github.com/fntaszeia/ClipboardManager${NC}"
echo ""
echo -e "${GREEN}Happy clipboard managing! 📋✨${NC}"