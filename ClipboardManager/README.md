# Clipboard Manager for macOS

A simple and efficient clipboard manager for macOS that tracks your clipboard history and allows you to easily access and paste previous clipboard items.

## Features

- **Clipboard History**: Stores up to 10 clipboard items
- **Image Support**: Handles both text and image/screenshot clipboard content
- **Menu Bar Integration**: Convenient access through the menu bar
- **Double-Click to Paste**: Simply double-click any item to paste it
- **Real-time Monitoring**: Automatically monitors clipboard changes
- **Native macOS Interface**: Built with Swift and Cocoa for optimal performance

## Installation

1. Compile the application:
   ```bash
   ./compile.sh
   ```

2. Run the application:
   ```bash
   ./ClipboardManager
   ```

## Usage

1. **Launch the App**: Run the compiled executable
2. **Access History**: Click the clipboard icon in the menu bar or select "Show Clipboard"
3. **Paste Items**: Double-click any item in the history to paste it
4. **View Content**: Text and images are displayed with timestamps
5. **Quit**: Select "Quit" from the menu bar or press Cmd+Q

## How It Works

- The app monitors your clipboard every 0.5 seconds for changes
- When new content is copied, it's automatically added to the history
- The history maintains the 10 most recent items
- Images and screenshots are displayed as thumbnails alongside text
- Double-clicking an item copies it back to the clipboard

## Technical Details

- Written in Swift using Cocoa framework
- Uses NSPasteboard for clipboard operations
- NSTableView for displaying clipboard history
- Menu bar integration with NSStatusBar
- Automatic memory management with 10-item limit

## Requirements

- macOS 10.15 or later
- Swift compiler (included with Xcode)

## File Structure

- `main.swift` - Main application code
- `compile.sh` - Compilation script
- `README.md` - This documentation
- `ClipboardManager` - Compiled executable (after running compile.sh)

## License

MIT License - Feel free to modify and distribute as needed.