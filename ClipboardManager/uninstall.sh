#!/bin/bash

# ClipboardManager Uninstaller Script
# This script removes ClipboardManager and all associated files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation paths
INSTALL_DIR="$HOME/Applications/ClipboardManager"
PLIST_PATH="$HOME/Library/LaunchAgents/com.clipboardmanager.plist"
LOG_FILE="$HOME/Library/Logs/ClipboardManager.log"
SYMLINK_PATH="$HOME/bin/clipboardmanager"

echo -e "${RED}🗑️  ClipboardManager Uninstaller${NC}"
echo -e "${RED}================================${NC}"
echo ""

# Confirm uninstallation
echo -e "${YELLOW}⚠️  This will completely remove ClipboardManager and all associated files${NC}"
echo ""
echo "The following will be removed:"
echo "• Application files: $INSTALL_DIR"
echo "• Auto-startup configuration: $PLIST_PATH"
echo "• Log file: $LOG_FILE"
echo "• Symlink: $SYMLINK_PATH"
echo ""
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}⏭️  Uninstallation cancelled${NC}"
    exit 0
fi

echo -e "${BLUE}🛑 Stopping ClipboardManager...${NC}"

# Stop the application
pkill -f "ClipboardManager" 2>/dev/null || true
echo -e "${GREEN}✅ Application stopped${NC}"

# Remove auto-startup configuration
if [[ -f "$PLIST_PATH" ]]; then
    echo -e "${BLUE}📤 Removing auto-startup configuration...${NC}"
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    rm -f "$PLIST_PATH"
    echo -e "${GREEN}✅ Auto-startup configuration removed${NC}"
else
    echo -e "${YELLOW}⏭️  No auto-startup configuration found${NC}"
fi

# Remove log file
if [[ -f "$LOG_FILE" ]]; then
    echo -e "${BLUE}📝 Removing log file...${NC}"
    rm -f "$LOG_FILE"
    echo -e "${GREEN}✅ Log file removed${NC}"
else
    echo -e "${YELLOW}⏭️  No log file found${NC}"
fi

# Remove symlink
if [[ -L "$SYMLINK_PATH" ]]; then
    echo -e "${BLUE}🔗 Removing symlink...${NC}"
    rm -f "$SYMLINK_PATH"
    echo -e "${GREEN}✅ Symlink removed${NC}"
else
    echo -e "${YELLOW}⏭️  No symlink found${NC}"
fi

# Remove installation directory
if [[ -d "$INSTALL_DIR" ]]; then
    echo -e "${BLUE}📁 Removing installation directory...${NC}"
    rm -rf "$INSTALL_DIR"
    echo -e "${GREEN}✅ Installation directory removed${NC}"
else
    echo -e "${YELLOW}⏭️  No installation directory found${NC}"
fi

# Clean up empty directories
if [[ -d "$HOME/Applications" ]] && [[ -z "$(ls -A "$HOME/Applications")" ]]; then
    echo -e "${BLUE}🧹 Cleaning up empty directories...${NC}"
    rmdir "$HOME/Applications" 2>/dev/null || true
fi

if [[ -d "$HOME/bin" ]] && [[ -z "$(ls -A "$HOME/bin")" ]]; then
    rmdir "$HOME/bin" 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}🎉 Uninstallation Complete!${NC}"
echo -e "${GREEN}==========================${NC}"
echo ""
echo -e "${GREEN}✅ ClipboardManager has been completely removed${NC}"
echo -e "${GREEN}✅ All configuration files cleaned up${NC}"
echo -e "${GREEN}✅ Auto-startup disabled${NC}"
echo ""
echo -e "${BLUE}📋 What was removed:${NC}"
echo "• Application files and executable"
echo "• Menu bar integration"
echo "• Auto-startup configuration"
echo "• Log files and symlinks"
echo ""
echo -e "${YELLOW}Note:${NC} Any clipboard history was stored in memory only"
echo -e "${YELLOW}      and has been automatically cleared${NC}"
echo ""
echo -e "${BLUE}Thank you for using ClipboardManager! 📋${NC}"
echo ""
echo -e "${GREEN}To reinstall in the future:${NC}"
echo "curl -fsSL https://raw.githubusercontent.com/fntaszeia/ClipboardManager/main/install.sh | bash"