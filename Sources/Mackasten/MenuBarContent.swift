import AppKit

/// Pure-data description of what to display in the menubar: the icon and the menu items.
/// Pass an instance to `MenuBar.install(_:)` to apply it.
struct MenuBarContent {
    /// SF Symbol name for the status item button image (e.g. "checklist").
    let symbolName: String
    /// VoiceOver label for the status item button.
    let accessibilityDescription: String
    let menuItems: [NSMenuItem]
}
