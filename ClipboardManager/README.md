# 📋 ClipboardManager for macOS

A powerful, feature-rich clipboard manager for macOS that provides seamless clipboard history management with real-time updates and beautiful animations.

## ✨ Features

- **🔄 Real-time Clipboard History**: Stores up to 10 clipboard items with instant updates
- **🖼️ Image & Screenshot Support**: Full support for images with thumbnail previews
- **🔗 Smart Link Detection**: Automatically detects URLs with click-to-copy and Option+click-to-open
- **🎨 Menu Bar Integration**: Clean, native macOS menu bar interface
- **⚡ Live Animations**: Beautiful animated feedback when copying new items
- **🔊 Audio Feedback**: Sound notifications for new clipboard items
- **⌨️ Keyboard Shortcuts**: Quick access and easy interaction
- **🎯 Seamless Updates**: New items appear instantly while menu is open

## 🚀 Quick Installation

### Option 1: One-Command Install
```bash
curl -fsSL https://raw.githubusercontent.com/fntaszeia/ClipboardManager/main/install.sh | bash
```

### Option 2: Manual Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/fntaszeia/ClipboardManager.git
   cd ClipboardManager
   ```

2. **Run the installer:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Or compile manually:**
   ```bash
   ./compile.sh
   ./ClipboardManager
   ```

## 🔧 Auto-Startup Setup

### Automatic Method (Recommended)
The installer will ask if you want to enable auto-startup. Choose "Yes" to automatically start ClipboardManager when your Mac boots.

### Manual Method
1. **Create launch agent:**
   ```bash
   ./setup_autostart.sh
   ```

2. **Or manually:**
   - Open **System Preferences** → **Users & Groups** → **Login Items**
   - Click the **+** button
   - Navigate to your ClipboardManager folder
   - Select `ClipboardManager.app`
   - Click **Add**

## 📖 Usage Guide

### Basic Usage
1. **Launch**: The app starts automatically or run `./ClipboardManager`
2. **Access**: Click the 📋 icon in your menu bar
3. **Copy Items**: Click any item to copy it to clipboard
4. **View History**: See your last 10 clipboard items with timestamps

### Advanced Features
- **Links**: 
  - **Click** → Copy link to clipboard
  - **Option+Click** → Open link in browser
- **Images**: View thumbnail previews in the menu
- **Real-time Updates**: Copy while menu is open to see instant updates
- **Animations**: Watch items appear with sparkle effects

### Keyboard Shortcuts
- **Click menu bar icon** → Open clipboard history
- **Double-click item** → Copy to clipboard
- **Option+Click link** → Open in browser
- **Cmd+U** → Check for updates
- **Cmd+Q** → Quit application

## 🎬 How It Works

### Real-time Monitoring
- Monitors clipboard changes every 0.1 seconds when menu is open
- Standard 0.5-second monitoring when running in background
- Automatically detects text, links, and images

### Smart Features
- **Link Detection**: Automatically identifies URLs (http, https, ftp)
- **Image Handling**: Supports screenshots and copied images
- **Memory Management**: Maintains exactly 10 items, removing oldest when limit reached
- **Live Updates**: Menu updates in real-time without closing/reopening

## 🔧 Technical Details

### Built With
- **Language**: Swift 5.0+
- **Framework**: Cocoa (Native macOS)
- **Architecture**: Event-driven with NSPasteboard monitoring
- **UI**: NSMenu with NSStatusBar integration

### System Requirements
- **macOS**: 10.15 (Catalina) or later
- **Architecture**: Intel or Apple Silicon
- **Memory**: Minimal footprint (~5MB)
- **Permissions**: Accessibility access (requested automatically)

### File Structure
```
ClipboardManager/
├── main.swift              # Main application source
├── compile.sh              # Compilation script
├── install.sh              # One-click installer
├── setup_autostart.sh      # Auto-startup configuration
├── uninstall.sh            # Removal script
├── ClipboardManager.app/   # Complete app bundle
├── README.md               # This documentation
└── .gitignore             # Git exclusions
```

## 🛠️ Development

### Building from Source
```bash
# Clone repository
git clone https://github.com/fntaszeia/ClipboardManager.git
cd ClipboardManager

# Compile
swiftc -o ClipboardManager main.swift -framework Cocoa -framework Foundation

# Run
./ClipboardManager
```

### Customization
- **History Limit**: Change `maxHistory` in `main.swift`
- **Monitoring Frequency**: Adjust timer intervals
- **Animations**: Modify animation sequences and timing
- **Sounds**: Customize audio feedback

## 🔄 Updating

### In-App Updates (Recommended)
1. **Click menu bar icon** → **Check for Updates**
2. **Choose "Update Now"** if updates are available
3. **App automatically downloads, compiles, and restarts**

### Manual Update
```bash
cd ClipboardManager
git pull origin main
./compile.sh
```

### Features:
- **One-click updates** directly from menu bar
- **Automatic compilation** after download
- **Seamless restart** to apply changes
- **Rollback protection** with error handling

## 🗑️ Uninstallation

### Automatic Removal
```bash
./uninstall.sh
```

### Manual Removal
1. **Stop the app**: Click menu bar → Quit
2. **Remove from Login Items**: System Preferences → Users & Groups → Login Items
3. **Delete files**: Remove ClipboardManager folder
4. **Clean launch agent**: `rm ~/Library/LaunchAgents/com.clipboardmanager.plist`

## 🐛 Troubleshooting

### Common Issues

**Q: App doesn't appear in menu bar**
- Check if app is running: `ps aux | grep ClipboardManager`
- Restart the app: `./ClipboardManager`
- Check permissions in System Preferences → Security & Privacy

**Q: Auto-start not working**
- Verify login item: System Preferences → Users & Groups → Login Items
- Check launch agent: `ls ~/Library/LaunchAgents/com.clipboardmanager.plist`
- Restart Mac and check

**Q: Clipboard not updating**
- Grant accessibility permissions: System Preferences → Security & Privacy → Accessibility
- Restart the application
- Check console for error messages

**Q: No sound feedback**
- Check system volume settings
- Verify sound effects are enabled in System Preferences → Sound

### Debug Mode
```bash
./ClipboardManager --debug
```

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature-name`
3. **Commit** changes: `git commit -am 'Add feature'`
4. **Push** to branch: `git push origin feature-name`
5. **Submit** a Pull Request

## 📄 License

MIT License - Feel free to modify and distribute as needed.

## 👨‍💻 Author

Created by **fntaszeia** with assistance from Claude AI.

---

⭐ **Star this repository** if you find it useful!

🐛 **Report issues** at: https://github.com/fntaszeia/ClipboardManager/issues