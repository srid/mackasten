import AppKit

/// Pulls the `menuId: String` out of a menu-click `sender` and hands it to a
/// per-source opener. Both `MailItemActionHandler` and `ReminderItemActionHandler`
/// route their `@objc` entry points through this so the guard/cast/dispatch idiom
/// lives once. The handlers stay as separate NSObjects because AppKit selector
/// dispatch requires distinct `@objc` method names.
enum MenuClickHandler {
    static func dispatch(sender: Any?, open: (String) -> Void) {
        guard
            let item = sender as? NSMenuItem,
            let menuId = item.representedObject as? String
        else {
            NSLog("[MenuClickHandler] dispatch: unexpected sender or missing menuId; sender=%@", String(describing: sender))
            return
        }
        open(menuId)
    }
}
