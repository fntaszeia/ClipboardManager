#!/bin/bash

# Auto-Startup Setup Script for ClipboardManager
# This script configures ClipboardManager to start automatically when you log in

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the current directory
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_PATH="$CURRENT_DIR/ClipboardManager"

echo -e "${BLUE}🚀 ClipboardManager Auto-Startup Setup${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# Check if ClipboardManager executable exists
if [[ ! -f "$APP_PATH" ]]; then
    echo -e "${RED}❌ ClipboardManager executable not found${NC}"
    echo -e "${RED}   Expected location: $APP_PATH${NC}"
    echo -e "${RED}   Please compile first: ./compile.sh${NC}"
    exit 1
fi

echo -e "${GREEN}✅ ClipboardManager executable found${NC}"

# Create LaunchAgents directory if it doesn't exist
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
mkdir -p "$LAUNCH_AGENTS_DIR"

# Define plist file path
PLIST_PATH="$LAUNCH_AGENTS_DIR/com.clipboardmanager.plist"

# Check if already configured
if [[ -f "$PLIST_PATH" ]]; then
    echo -e "${YELLOW}⚠️  Auto-startup already configured${NC}"
    echo -e "${YELLOW}   Existing plist: $PLIST_PATH${NC}"
    echo ""
    read -p "Replace existing configuration? (y/N): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}⏭️  Setup cancelled${NC}"
        exit 0
    fi
    
    # Unload existing launch agent
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    echo -e "${YELLOW}📤 Unloaded existing launch agent${NC}"
fi

# Create the launch agent plist
echo -e "${BLUE}📝 Creating launch agent configuration...${NC}"

cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.clipboardmanager</string>
    <key>ProgramArguments</key>
    <array>
        <string>$APP_PATH</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>LaunchOnlyOnce</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/ClipboardManager.log</string>
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/ClipboardManager.log</string>
</dict>
</plist>
EOF

echo -e "${GREEN}✅ Launch agent plist created${NC}"

# Set proper permissions
chmod 644 "$PLIST_PATH"

# Load the launch agent
echo -e "${BLUE}📥 Loading launch agent...${NC}"
launchctl load "$PLIST_PATH"

if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✅ Launch agent loaded successfully${NC}"
else
    echo -e "${RED}❌ Failed to load launch agent${NC}"
    echo -e "${RED}   You may need to restart your Mac${NC}"
fi

# Test the setup
echo -e "${BLUE}🧪 Testing auto-startup setup...${NC}"
launchctl list | grep com.clipboardmanager > /dev/null

if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✅ Auto-startup test passed${NC}"
    echo -e "${GREEN}   ClipboardManager will start automatically on next login${NC}"
else
    echo -e "${YELLOW}⚠️  Auto-startup test inconclusive${NC}"
    echo -e "${YELLOW}   Try logging out and back in to test${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Auto-Startup Setup Complete!${NC}"
echo -e "${GREEN}==================================${NC}"
echo ""
echo -e "${BLUE}📍 Configuration saved to:${NC} $PLIST_PATH"
echo -e "${BLUE}📋 Application path:${NC} $APP_PATH"
echo -e "${BLUE}📝 Log file:${NC} $HOME/Library/Logs/ClipboardManager.log"
echo ""
echo -e "${YELLOW}What happens next:${NC}"
echo "• ClipboardManager will start automatically when you log in"
echo "• Look for the 📋 icon in your menu bar"
echo "• No need to manually start the application"
echo ""
echo -e "${BLUE}To disable auto-startup:${NC}"
echo "launchctl unload $PLIST_PATH"
echo "rm $PLIST_PATH"
echo ""
echo -e "${GREEN}Happy clipboard managing! 📋✨${NC}"