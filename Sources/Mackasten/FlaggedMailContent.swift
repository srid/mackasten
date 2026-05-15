import AppKit

/// Builds the menu bar content from the list of flagged mails read out of Apple Mail.
/// Pure — the AppleScript boundary lives in `FlaggedMailReader`.
enum FlaggedMailContent {
    static let symbolName = "flag"
    static let accessibilityDescription = "Mackasten — Flagged mail"
    static let emptyPlaceholder = "No flagged mail"

    static func make(from mails: [FlaggedMail]) -> MenuBarContent {
        let mailItems: [NSMenuItem] = mails.isEmpty
            ? [disabledItem(title: emptyPlaceholder)]
            : mails.map { disabledItem(title: $0.subject) }

        return MenuBarContent(
            symbolName: symbolName,
            accessibilityDescription: accessibilityDescription,
            menuItems: mailItems + [
                NSMenuItem.separator(),
                NSMenuItem(
                    title: "Quit",
                    action: #selector(NSApplication.terminate(_:)),
                    keyEquivalent: "q"
                ),
            ]
        )
    }

    private static func disabledItem(title: String) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }
}
