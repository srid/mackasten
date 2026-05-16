import AppKit
import Foundation

/// AppKit target that opens a Mail message by id when its menu item is clicked.
/// Lives at the composition root and is passed to `SourceAppContent.menuItems`.
/// Held as a strong reference by `main.swift` — NSMenuItem.target is weak.
final class MailItemActionHandler: NSObject {
    @objc func openMessage(_ sender: Any?) {
        MenuClickHandler.dispatch(sender: sender) { menuId in
            guard let id = Int(menuId) else {
                NSLog("[MailItemActionHandler] menuId is not a valid integer: %@", menuId)
                return
            }
            Self.open(messageId: id)
        }
    }

    private static func open(messageId: Int) {
        let source = """
        tell application "Mail"
            set theMessage to first message of inbox whose id is \(messageId)
            open theMessage
            activate
        end tell
        """
        guard let script = NSAppleScript(source: source) else { return }
        var error: NSDictionary?
        script.executeAndReturnError(&error)
        // Best-effort open — log failures but don't propagate (no UI feedback path).
        if let error { NSLog("[MailItemActionHandler] AppleScript failed: %@", error) }
    }
}
