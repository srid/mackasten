import AppKit

/// Builds the flagged-reminders portion of the menu bar (icon + reminder-list items).
/// App-lifecycle fixtures like the Quit footer live in the composition root, not here.
/// Pure — the AppleScript boundary lives in `ReminderReader`.
enum FlaggedReminderContent {
    static let symbolName = "checklist"
    static let accessibilityDescription = "Mackasten — Reminders requiring focus"
    static let emptyPlaceholder = "No reminders requiring focus"

    static func make(
        from reminders: [ReminderItem],
        onSelect: MenuItemAction? = nil,
        footer: [NSMenuItem] = []
    ) -> MenuBarContent {
        let reminderItems: [NSMenuItem] = reminders.isEmpty
            ? [disabledItem(title: emptyPlaceholder)]
            : reminders.map { reminderItem(for: $0, onSelect: onSelect) }

        return MenuBarContent(
            symbolName: symbolName,
            accessibilityDescription: accessibilityDescription,
            menuItems: reminderItems + footer
        )
    }

    private static func reminderItem(for reminder: ReminderItem, onSelect: MenuItemAction?) -> NSMenuItem {
        let item = NSMenuItem(title: reminder.title, action: onSelect?.selector, keyEquivalent: "")
        item.target = onSelect?.target
        item.representedObject = reminder.id
        item.isEnabled = onSelect != nil
        return item
    }

    private static func disabledItem(title: String) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }
}
