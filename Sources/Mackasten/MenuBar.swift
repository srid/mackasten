import AppKit

enum MenuBar {
    static let title = "Hello World"
    static let symbolName = "checklist"
    static let accessibilityDescription = "Mackasten"

    private static var statusItem: NSStatusItem?

    static func install(into statusBar: NSStatusBar = .system) {
        let item = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        item.button?.image = NSImage(
            systemSymbolName: symbolName,
            accessibilityDescription: accessibilityDescription
        )

        let menu = NSMenu()
        menu.addItem(withTitle: title, action: nil, keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(
            title: "Quit",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        ))
        item.menu = menu

        statusItem = item
    }
}
