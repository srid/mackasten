import AppKit

/// Couples the target and selector that a menu item should fire on click. They only
/// make sense together — keeping them in one value stops content builders from
/// taking two correlated parameters. Shared by mail and reminder menus.
struct MenuItemAction {
    let target: AnyObject
    let selector: Selector
}
