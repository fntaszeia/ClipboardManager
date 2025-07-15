import Cocoa
import Foundation

class ClipboardManager {
    private var clipboardHistory: [ClipboardItem] = []
    private let maxHistory = 10
    private let pasteboard = NSPasteboard.general
    private var lastChangeCount = 0
    
    struct ClipboardItem {
        let id = UUID()
        let content: String
        let image: NSImage?
        let timestamp: Date
        let isLink: Bool
        
        init(content: String, image: NSImage? = nil) {
            self.content = content
            self.image = image
            self.timestamp = Date()
            self.isLink = ClipboardItem.isValidURL(content)
        }
        
        static func isValidURL(_ string: String) -> Bool {
            if let url = URL(string: string.trimmingCharacters(in: .whitespacesAndNewlines)) {
                return url.scheme != nil && (url.scheme == "http" || url.scheme == "https" || url.scheme == "ftp")
            }
            return false
        }
    }
    
    func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.checkClipboard()
        }
    }
    
    func checkClipboard() {
        let currentChangeCount = pasteboard.changeCount
        
        if currentChangeCount != lastChangeCount {
            lastChangeCount = currentChangeCount
            
            var newItem: ClipboardItem?
            
            if let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage {
                newItem = ClipboardItem(content: "Image", image: image)
                print("📸 New image detected in clipboard!")
            } else if let string = pasteboard.string(forType: .string) {
                newItem = ClipboardItem(content: string)
                print("📝 New text detected in clipboard: \(string.prefix(30))...")
            }
            
            if let item = newItem {
                addToHistory(item)
                print("✅ Added to history, total items: \(clipboardHistory.count)")
            }
        }
    }
    
    private func addToHistory(_ item: ClipboardItem) {
        clipboardHistory.insert(item, at: 0)
        
        if clipboardHistory.count > maxHistory {
            clipboardHistory.removeLast()
        }
        
        NotificationCenter.default.post(name: .clipboardDidUpdate, object: clipboardHistory)
        
        // Show animation for new item
        showNewItemAnimation(item)
    }
    
    private func showNewItemAnimation(_ item: ClipboardItem) {
        print("🎬 Animation triggered for new item")
        // Simple console feedback for now - notifications cause crashes in non-bundle apps
        if item.image != nil {
            print("📸 Image copied animation")
        } else if item.isLink {
            print("🔗 Link copied animation")
        } else {
            let preview = item.content.count > 40 ? String(item.content.prefix(40)) + "..." : item.content
            print("📝 Text copied: \(preview)")
        }
    }
    
    func getHistory() -> [ClipboardItem] {
        return clipboardHistory
    }
    
    func pasteItem(_ item: ClipboardItem) {
        pasteboard.clearContents()
        
        if let image = item.image {
            pasteboard.writeObjects([image])
        } else {
            // For links, ensure the full URL is copied
            if item.isLink {
                pasteboard.setString(item.content, forType: .string)
                // Also add URL type for better compatibility
                if let url = URL(string: item.content) {
                    pasteboard.setString(url.absoluteString, forType: .URL)
                }
            } else {
                pasteboard.setString(item.content, forType: .string)
            }
        }
    }
}

extension Notification.Name {
    static let clipboardDidUpdate = Notification.Name("clipboardDidUpdate")
}


class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private let clipboardManager = ClipboardManager()
    private var clipboardItems: [ClipboardManager.ClipboardItem] = []
    private var isMenuOpen = false
    private var menuUpdateTimer: Timer?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("Application launching...")
        
        // Set up as background app that can still show UI
        NSApp.setActivationPolicy(.accessory)
        
        setupStatusBar()
        setupObservers()
        clipboardManager.startMonitoring()
        
        print("Application launched successfully!")
    }
    
    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            // Try system symbol first, fallback to text
            if let image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Clipboard Manager") {
                button.image = image
            } else {
                // Fallback to text if system symbol not available
                button.title = "📋"
            }
        }
        
        // Create initial menu with hover detection
        updateMenuWithHoverDetection()
        
        // Debug: Print that status bar was set up
        print("Status bar item created successfully")
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clipboardDidUpdate),
            name: .clipboardDidUpdate,
            object: nil
        )
    }
    
    @objc private func clipboardDidUpdate(_ notification: Notification) {
        if let items = notification.object as? [ClipboardManager.ClipboardItem] {
            let oldCount = clipboardItems.count
            let oldFirstId = clipboardItems.first?.id
            clipboardItems = items
            
            print("🔄 Clipboard updated! Menu open: \(isMenuOpen), Items: \(items.count)")
            
            DispatchQueue.main.async {
                // Check if this is a new item (count increased or first item changed)
                let hasNewItem = items.count > oldCount || (items.count > 0 && items[0].id != oldFirstId)
                
                print("📊 Has new item: \(hasNewItem), Old count: \(oldCount), New count: \(items.count)")
                
                if hasNewItem {
                    // If menu is open, update it immediately with animation
                    if self.isMenuOpen {
                        print("🎯 Updating menu with live animation!")
                        self.updateMenuWithNewItemAnimationLive()
                    } else {
                        print("🎯 Updating menu with normal animation!")
                        self.updateMenuWithNewItemAnimation()
                    }
                } else {
                    self.updateMenuWithHoverDetection()
                }
            }
        }
    }
    
    private func updateMenu() {
        updateMenuWithHoverDetection()
    }
    
    private func updateMenuWithHoverDetection() {
        let menu = NSMenu()
        menu.delegate = self
        
        // Add clipboard items
        if clipboardItems.isEmpty {
            let emptyItem = NSMenuItem(title: "No clipboard history", action: nil, keyEquivalent: "")
            emptyItem.isEnabled = false
            menu.addItem(emptyItem)
        } else {
            for (index, item) in clipboardItems.enumerated() {
                let menuItem = createMenuItem(for: item, at: index)
                menu.addItem(menuItem)
            }
        }
        
        // Add separator and quit option
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    private func updateMenuWithNewItemAnimation() {
        let menu = NSMenu()
        menu.delegate = self
        
        // Add clipboard items with animation for the first item
        if clipboardItems.isEmpty {
            let emptyItem = NSMenuItem(title: "No clipboard history", action: nil, keyEquivalent: "")
            emptyItem.isEnabled = false
            menu.addItem(emptyItem)
        } else {
            for (index, item) in clipboardItems.enumerated() {
                let menuItem = createMenuItem(for: item, at: index)
                
                // Animate the first (newest) item
                if index == 0 {
                    menuItem.title = "✨ " + menuItem.title
                    
                    // Remove the sparkle after animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        if let currentMenu = self.statusItem.menu,
                           currentMenu.items.count > index {
                            let originalTitle = menuItem.title.replacingOccurrences(of: "✨ ", with: "")
                            menuItem.title = originalTitle
                        }
                    }
                }
                
                menu.addItem(menuItem)
            }
        }
        
        // Add separator and quit option
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    private func updateMenuWithNewItemAnimationLive() {
        print("🎯 updateMenuWithNewItemAnimationLive called")
        
        // Play beep sound immediately and loudly
        NSSound.beep()
        print("🔊 Beep sound played")
        
        // The fundamental issue: NSMenu doesn't update display when open
        // Solution: Force recreation with immediate reopen
        DispatchQueue.main.async {
            // Store that menu was open
            let wasOpen = self.statusItem.menu != nil
            
            // Force close menu
            self.statusItem.menu = nil
            
            // Create new menu with updated items
            let newMenu = NSMenu()
            newMenu.delegate = self
            
            // Add all clipboard items
            for (index, item) in self.clipboardItems.enumerated() {
                let menuItem = self.createMenuItem(for: item, at: index)
                
                // Animate the first (newest) item
                if index == 0 {
                    menuItem.title = "⚡ JUST COPIED: " + menuItem.title
                    
                    // Animation sequence
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if let menu = self.statusItem.menu, menu.items.count > 0 {
                            menu.items[0].title = "✨ NEW: " + menu.items[0].title.replacingOccurrences(of: "⚡ JUST COPIED: ", with: "")
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        if let menu = self.statusItem.menu, menu.items.count > 0 {
                            menu.items[0].title = "🆕 " + menu.items[0].title.replacingOccurrences(of: "✨ NEW: ", with: "")
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        if let menu = self.statusItem.menu, menu.items.count > 0 {
                            menu.items[0].title = "💫 " + menu.items[0].title.replacingOccurrences(of: "🆕 ", with: "")
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        if let menu = self.statusItem.menu, menu.items.count > 0 {
                            let originalTitle = menu.items[0].title.replacingOccurrences(of: "💫 ", with: "")
                            menu.items[0].title = originalTitle
                        }
                    }
                }
                
                newMenu.addItem(menuItem)
            }
            
            // Add separator and quit
            newMenu.addItem(NSMenuItem.separator())
            newMenu.addItem(NSMenuItem(title: "Quit", action: #selector(self.quit), keyEquivalent: "q"))
            
            // Set the new menu
            self.statusItem.menu = newMenu
            
            // If menu was open, immediately reopen it
            if wasOpen {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    if let button = self.statusItem.button {
                        button.performClick(nil)
                    }
                }
            }
            
            print("🎯 Menu recreated and reopened with new items")
        }
    }
    
    private func createMenuItem(for item: ClipboardManager.ClipboardItem, at index: Int) -> NSMenuItem {
        let title = createMenuTitle(for: item)
        let menuItem = NSMenuItem(title: title, action: #selector(clipboardItemClicked(_:)), keyEquivalent: "")
        menuItem.target = self
        menuItem.tag = index
        
        // Add image preview for images
        if let image = item.image {
            let resizedImage = resizeImage(image, to: NSSize(width: 64, height: 64))
            menuItem.image = resizedImage
        }
        
        // Add tooltips with helpful information
        if item.isLink {
            menuItem.toolTip = "Link: \(item.content)\n\nClick to copy • Option+Click to open in browser"
        } else if item.image != nil {
            menuItem.toolTip = "Image copied at \(formatTime(item.timestamp))\n\nClick to copy to clipboard"
        } else {
            let preview = item.content.count > 100 ? String(item.content.prefix(100)) + "..." : item.content
            menuItem.toolTip = "Text: \(preview)\n\nCopied at \(formatTime(item.timestamp))"
        }
        
        return menuItem
    }
    
    private func createMenuTitle(for item: ClipboardManager.ClipboardItem) -> String {
        if item.image != nil {
            return "📸 Image"
        } else if item.isLink {
            // For links, show the domain if possible
            if let url = URL(string: item.content), let host = url.host {
                return "🔗 \(host)"
            } else {
                return "🔗 Link"
            }
        } else {
            // Truncate long text and replace newlines with spaces
            let cleanContent = item.content.replacingOccurrences(of: "\n", with: " ")
            let truncated = cleanContent.count > 50 ? String(cleanContent.prefix(50)) + "..." : cleanContent
            return truncated
        }
    }
    
    private func resizeImage(_ image: NSImage, to size: NSSize) -> NSImage {
        let resizedImage = NSImage(size: size)
        resizedImage.lockFocus()
        
        let imageRect = NSRect(origin: .zero, size: size)
        let originalSize = image.size
        
        // Calculate aspect ratio to maintain proportions
        let aspectRatio = originalSize.width / originalSize.height
        let newAspectRatio = size.width / size.height
        
        var drawRect = imageRect
        if aspectRatio > newAspectRatio {
            // Image is wider, fit to width
            let newHeight = size.width / aspectRatio
            drawRect.origin.y = (size.height - newHeight) / 2
            drawRect.size.height = newHeight
        } else {
            // Image is taller, fit to height
            let newWidth = size.height * aspectRatio
            drawRect.origin.x = (size.width - newWidth) / 2
            drawRect.size.width = newWidth
        }
        
        image.draw(in: drawRect)
        resizedImage.unlockFocus()
        
        return resizedImage
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    @objc private func clipboardItemClicked(_ sender: NSMenuItem) {
        let index = sender.tag
        guard index >= 0 && index < clipboardItems.count else { return }
        
        let item = clipboardItems[index]
        
        // Special handling for links - show submenu with options
        if item.isLink && NSEvent.modifierFlags.contains(.option) {
            // Option+click opens the link in browser
            if let url = URL(string: item.content) {
                NSWorkspace.shared.open(url)
                sender.title = "🌐 Opened in browser"
                animateMenuItemSuccess(sender)
            }
        } else {
            // Regular click copies to clipboard
            clipboardManager.pasteItem(item)
            
            // Visual feedback with animation
            if item.isLink {
                sender.title = "✓ Link copied to clipboard"
            } else if item.image != nil {
                sender.title = "✓ Image copied to clipboard"
            } else {
                sender.title = "✓ Text copied to clipboard"
            }
            
            animateMenuItemSuccess(sender)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.updateMenu()
        }
    }
    
    private func animateMenuItemSuccess(_ menuItem: NSMenuItem) {
        // Create a subtle animation effect
        let originalTitle = menuItem.title
        
        // Flash effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            menuItem.title = "✨ " + originalTitle
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            menuItem.title = originalTitle
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            menuItem.title = "✨ " + originalTitle
        }
    }
    
    @objc private func quit() {
        NSApp.terminate(nil)
    }
}

// MARK: - NSMenuDelegate
extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        isMenuOpen = true
        print("📋 Menu opened! Starting active monitoring...")
        
        // Force refresh clipboard check when menu opens
        clipboardManager.checkClipboard()
        
        // Start monitoring more frequently while menu is open
        startActiveMonitoring()
        
        // Update the menu with latest items
        DispatchQueue.main.async {
            self.updateMenuWithHoverDetection()
        }
    }
    
    func menuDidClose(_ menu: NSMenu) {
        isMenuOpen = false
        print("📋 Menu closed! Stopping active monitoring...")
        
        // Stop active monitoring
        stopActiveMonitoring()
    }
    
    private func startActiveMonitoring() {
        // Check clipboard more frequently while menu is open
        print("⏰ Starting active monitoring timer...")
        menuUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.clipboardManager.checkClipboard()
        }
    }
    
    private func stopActiveMonitoring() {
        menuUpdateTimer?.invalidate()
        menuUpdateTimer = nil
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()