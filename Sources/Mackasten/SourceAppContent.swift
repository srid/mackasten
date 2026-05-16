import AppKit

/// Builds the rows for one source-app section of the unified focus menu. Generic
/// over `SourceAppItem` so Mail messages, Reminders, and future sources (Calendar)
/// share the same row-rendering code — only the icon and empty-state copy differ.
enum SourceAppContent {
    static func menuItems<T: SourceAppItem>(
        from items: [T],
        rowSymbolName: String,
        emptyPlaceholder: String,
        onSelect: MenuItemAction? = nil
    ) -> [NSMenuItem] {
        if items.isEmpty {
            return [MenuRow.disabled(title: emptyPlaceholder)]
        }
        return items.map { row(for: $0, rowSymbolName: rowSymbolName, onSelect: onSelect) }
    }

    private static func row(
        for item: some SourceAppItem,
        rowSymbolName: String,
        onSelect: MenuItemAction?
    ) -> NSMenuItem {
        let menuItem = NSMenuItem(title: item.displayLabel, action: onSelect?.selector, keyEquivalent: "")
        menuItem.target = onSelect?.target
        menuItem.representedObject = item.menuId
        menuItem.image = MenuRow.icon(named: rowSymbolName)
        menuItem.isEnabled = onSelect != nil
        return menuItem
    }
}
