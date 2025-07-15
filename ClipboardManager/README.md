# 📋 ClipboardManager for macOS

<div align="center">

![ClipboardManager Demo](https://img.shields.io/badge/macOS-10.15+-blue?style=for-the-badge&logo=apple)
![Swift](https://img.shields.io/badge/Swift-5.0+-orange?style=for-the-badge&logo=swift)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**A powerful, feature-rich clipboard manager for macOS that provides seamless clipboard history management with real-time updates and beautiful animations.**

[🚀 Quick Install](#-quick-installation) • [📖 Features](#-features) • [🎬 Demo](#-how-it-works) • [📋 Usage](#-usage-guide) • [🔧 Development](#-development)

</div>

---

## 🎯 **Quick Start - Install in 30 seconds**

### **Option 1: One-Command Install (Recommended)**
```bash
curl -fsSL https://raw.githubusercontent.com/fntaszeia/ClipboardManager/main/install.sh | bash
```

### **Option 2: Manual Install**
```bash
git clone https://github.com/fntaszeia/ClipboardManager.git
cd ClipboardManager
chmod +x install.sh
./install.sh
```

**That's it!** Look for the 📋 icon in your menu bar and start managing your clipboard like a pro!

## ✨ Features

<table>
<tr>
<td width="50%">

### 🔄 **Real-time Clipboard History**
- Stores up to 10 clipboard items
- Instant updates while menu is open
- Automatic cleanup of old items

### 🖼️ **Image & Screenshot Support**
- Full support for images with thumbnails
- Perfect for screenshots and copied images
- Visual previews in menu

### 🔗 **Smart Link Detection**
- Automatically detects URLs
- Click to copy, Option+click to open
- Supports http, https, and ftp links

</td>
<td width="50%">

### 🎨 **Native macOS Integration**
- Clean menu bar interface
- Follows macOS design principles
- Background app with minimal footprint

### ⚡ **Live Animations & Feedback**
- Beautiful animated feedback
- Sound notifications for new items
- Sparkle effects for new clipboard items

### 🔄 **In-App Updates**
- One-click updates from menu bar
- Automatic download and installation
- No manual updating required

</td>
</tr>
</table>

---

## 🎬 **See It In Action**

### **Quick Demo:**
1. **Install** → Run the one-command installer
2. **Look** → Find 📋 in your menu bar
3. **Copy** → Copy any text, image, or link
4. **Click** → Open clipboard history from menu bar
5. **Use** → Click any item to copy it back
6. **Update** → Click "Check for Updates" to get new features

### **Menu Preview:**
```
📋 ClipboardManager
├── 📝 Your latest copied text appears here...
├── 🔗 https://github.com/fntaszeia/ClipboardManager
├── 📸 Screenshot from 2:30 PM
├── 📝 Another text item you copied
├── ─────────────────────────────────────────
├── 🔄 Check for Updates
└── ❌ Quit
```

## 📋 **System Requirements**

<div align="center">

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| **macOS** | 10.15 (Catalina) | 11.0+ (Big Sur) |
| **Architecture** | Intel or Apple Silicon | Apple Silicon |
| **RAM** | 8GB | 16GB+ |
| **Storage** | 10MB | 50MB |
| **Internet** | Required for updates | Broadband |

</div>

---

## 🚀 **Installation Guide**

### **🎯 Option 1: One-Command Install (Recommended)**
```bash
curl -fsSL https://raw.githubusercontent.com/fntaszeia/ClipboardManager/main/install.sh | bash
```
**✅ Includes:** Auto-compilation, app bundle setup, auto-startup configuration

### **🛠️ Option 2: Manual Installation**
```bash
# 1. Clone the repository
git clone https://github.com/fntaszeia/ClipboardManager.git
cd ClipboardManager

# 2. Make installer executable and run
chmod +x install.sh
./install.sh

# 3. Follow the prompts for auto-startup setup
```

### **⚡ Option 3: Quick Development Setup**
```bash
# For developers who want to modify the code
git clone https://github.com/fntaszeia/ClipboardManager.git
cd ClipboardManager
./compile.sh
./ClipboardManager
```

### **🔧 What the Installer Does:**
1. **✅ Checks macOS compatibility** (10.15+ required)
2. **✅ Verifies Xcode Command Line Tools** (installs if missing)
3. **✅ Compiles the application** with Swift compiler
4. **✅ Creates app bundle** for proper macOS integration
5. **✅ Sets up auto-startup** (optional - you choose)
6. **✅ Creates desktop shortcut** and menu bar integration
7. **✅ Starts the application** immediately

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

---

## 🌟 **Support This Project**

<div align="center">

### **Found this useful? Give it a star! ⭐**

[![GitHub stars](https://img.shields.io/github/stars/fntaszeia/ClipboardManager?style=social)](https://github.com/fntaszeia/ClipboardManager/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fntaszeia/ClipboardManager?style=social)](https://github.com/fntaszeia/ClipboardManager/network/members)
[![GitHub issues](https://img.shields.io/github/issues/fntaszeia/ClipboardManager)](https://github.com/fntaszeia/ClipboardManager/issues)

**Your star helps others discover this project!**

</div>

---

## 📞 **Support & Community**

<div align="center">

| 🐛 **Found a Bug?** | 💡 **Have an Idea?** | 🤝 **Want to Contribute?** |
|---------------------|----------------------|---------------------------|
| [Report Issue](https://github.com/fntaszeia/ClipboardManager/issues/new) | [Request Feature](https://github.com/fntaszeia/ClipboardManager/issues/new) | [Submit PR](https://github.com/fntaszeia/ClipboardManager/pulls) |

</div>

---

## 📄 **License**

```
MIT License

Copyright (c) 2024 fntaszeia

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 👨‍💻 **Author**

<div align="center">

**Created by [fntaszeia](https://github.com/fntaszeia) with assistance from Claude AI**

[![GitHub followers](https://img.shields.io/github/followers/fntaszeia?style=social)](https://github.com/fntaszeia)

*Built with ❤️ for the macOS community*

</div>

---

<div align="center">

### **⭐ Star • 🍴 Fork • 📢 Share**

**Made with Swift and love for macOS users everywhere! 🍎**

</div>