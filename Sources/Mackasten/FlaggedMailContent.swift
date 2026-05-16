import AppKit

/// Builds the flagged-mail rows of the menu (one row per message, or a placeholder
/// when none). The composition root combines these rows with the reminder rows and
/// the Quit footer to form the single status item's menu.
/// Pure — the AppleScript boundary lives in `MailReader`.
enum FlaggedMailContent {
    static let rowSymbolName = "envelope"
    static let emptyPlaceholder = "No flagged mail"

    static func menuItems(
        from mails: [MailMessage],
        onSelect: MenuItemAction? = nil
    ) -> [NSMenuItem] {
        if mails.isEmpty {
            return [MenuRow.disabled(title: emptyPlaceholder)]
        }
        return mails.map { mailItem(for: $0, onSelect: onSelect) }
    }

    private static func mailItem(for mail: MailMessage, onSelect: MenuItemAction?) -> NSMenuItem {
        let item = NSMenuItem(title: mail.subject, action: onSelect?.selector, keyEquivalent: "")
        item.target = onSelect?.target
        item.representedObject = mail.id
        item.image = MenuRow.icon(named: rowSymbolName)
        item.isEnabled = onSelect != nil
        return item
    }
}
