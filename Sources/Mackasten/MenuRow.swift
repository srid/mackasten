import AppKit

/// Helpers shared by every menu-row builder: the per-row SF Symbol image and the
/// disabled-placeholder item shown when a section has no entries.
enum MenuRow {
    static func icon(named symbolName: String) -> NSImage? {
        let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: nil)
        image?.isTemplate = true
        return image
    }

    static func disabled(title: String) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }
}
