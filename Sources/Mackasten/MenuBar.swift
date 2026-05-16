import AppKit

/// Manages the single persistent NSStatusItem Mackasten owns in the system menu bar.
enum MenuBar {
    /// Retained to keep the status item alive; AppKit deallocates unreferenced items.
    private static var statusItem: NSStatusItem?

    @discardableResult
    static func install(_ content: MenuBarContent, into statusBar: NSStatusBar = .system) -> NSStatusItem {
        // Remove any previously installed item before creating a new one; without
        // this, repeated calls orphan old items in the status bar permanently.
        if let existing = statusItem {
            statusBar.removeStatusItem(existing)
        }

        let item = statusBar.statusItem(withLength: NSStatusItem.variableLength)

        guard let button = item.button else {
            preconditionFailure("NSStatusItem has no button — this should not happen on macOS 10.10+")
        }
        let image = NSImage(
            systemSymbolName: content.symbolName,
            accessibilityDescription: content.accessibilityDescription
        )
        precondition(image != nil, "SF Symbol '\(content.symbolName)' not found — check the symbol name")
        button.image = image

        let menu = NSMenu()
        for menuItem in content.menuItems {
            menu.addItem(menuItem)
        }
        item.menu = menu

        statusItem = item
        return item
    }
}
