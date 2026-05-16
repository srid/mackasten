import AppKit

/// Builds the flagged-mail portion of the menu bar (icon + the message-list items).
/// App-lifecycle fixtures like the Quit footer live in the composition root, not here.
/// Pure — the AppleScript boundary lives in `MailReader`.
enum FlaggedMailContent {
    static let symbolName = "flag"
    static let accessibilityDescription = "Mackasten — Flagged mail"
    static let emptyPlaceholder = "No flagged mail"

    static func make(
        from mails: [MailMessage],
        onSelect: MailItemAction? = nil,
        footer: [NSMenuItem] = []
    ) -> MenuBarContent {
        let mailItems: [NSMenuItem] = mails.isEmpty
            ? [disabledItem(title: emptyPlaceholder)]
            : mails.map { mailItem(for: $0, onSelect: onSelect) }

        return MenuBarContent(
            symbolName: symbolName,
            accessibilityDescription: accessibilityDescription,
            menuItems: mailItems + footer
        )
    }

    private static func mailItem(for mail: MailMessage, onSelect: MailItemAction?) -> NSMenuItem {
        let item = NSMenuItem(title: mail.subject, action: onSelect?.selector, keyEquivalent: "")
        item.target = onSelect?.target
        item.representedObject = mail.id
        item.isEnabled = onSelect != nil
        return item
    }

    private static func disabledItem(title: String) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }
}
