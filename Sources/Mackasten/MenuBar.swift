import AppKit

/// Manages the persistent NSStatusItems Mackasten owns in the system menu bar.
/// One `MenuBarContent` produces one icon + menu — multiple contents install side
/// by side, in the order given (left-to-right adjacent to other menu bar items).
enum MenuBar {
    /// Retained to keep status items alive; AppKit deallocates unreferenced items.
    private static var statusItems: [NSStatusItem] = []

    @discardableResult
    static func install(_ contents: [MenuBarContent], into statusBar: NSStatusBar = .system) -> [NSStatusItem] {
        // Remove any previously installed items before creating new ones; without
        // this, repeated calls orphan old items in the status bar permanently.
        for existing in statusItems {
            statusBar.removeStatusItem(existing)
        }
        statusItems.removeAll()

        statusItems = contents.map { content in install(content, into: statusBar) }
        return statusItems
    }

    private static func install(_ content: MenuBarContent, into statusBar: NSStatusBar) -> NSStatusItem {
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
        return item
    }
}
