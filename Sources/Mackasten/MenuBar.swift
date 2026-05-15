import AppKit

enum MenuBar {
    private static var statusItem: NSStatusItem?

    static func install(_ content: MenuBarContent, into statusBar: NSStatusBar = .system) {
        let item = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        item.button?.image = NSImage(
            systemSymbolName: content.symbolName,
            accessibilityDescription: content.accessibilityDescription
        )

        let menu = NSMenu()
        for menuItem in content.menuItems {
            menu.addItem(menuItem)
        }
        item.menu = menu

        statusItem = item
    }
}
