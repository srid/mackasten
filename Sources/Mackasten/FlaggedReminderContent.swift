import AppKit

/// Builds the reminder rows of the menu (one row per flagged-incomplete reminder, or
/// a placeholder when none). The composition root combines these rows with the mail
/// rows and the Quit footer to form the single status item's menu.
/// Pure — the AppleScript boundary lives in `ReminderReader`.
enum FlaggedReminderContent {
    static let rowSymbolName = "circle"
    static let emptyPlaceholder = "No reminders requiring focus"

    static func menuItems(
        from reminders: [ReminderItem],
        onSelect: MenuItemAction? = nil
    ) -> [NSMenuItem] {
        if reminders.isEmpty {
            return [MenuRow.disabled(title: emptyPlaceholder)]
        }
        return reminders.map { reminderItem(for: $0, onSelect: onSelect) }
    }

    private static func reminderItem(for reminder: ReminderItem, onSelect: MenuItemAction?) -> NSMenuItem {
        let item = NSMenuItem(title: reminder.title, action: onSelect?.selector, keyEquivalent: "")
        item.target = onSelect?.target
        item.representedObject = reminder.id
        item.image = MenuRow.icon(named: rowSymbolName)
        item.isEnabled = onSelect != nil
        return item
    }
}
