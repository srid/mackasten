import AppKit

enum HelloWorldContent {
    static let title = "Hello World"
    static let symbolName = "checklist"
    static let accessibilityDescription = "Mackasten"

    static func make() -> MenuBarContent {
        MenuBarContent(
            symbolName: symbolName,
            accessibilityDescription: accessibilityDescription,
            menuItems: [
                NSMenuItem(title: title, action: nil, keyEquivalent: ""),
                NSMenuItem.separator(),
                NSMenuItem(
                    title: "Quit",
                    action: #selector(NSApplication.terminate(_:)),
                    keyEquivalent: "q"
                ),
            ]
        )
    }
}
