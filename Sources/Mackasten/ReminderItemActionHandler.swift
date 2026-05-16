import AppKit
import Foundation

/// AppKit target that opens a Reminder by id when its menu item is clicked.
/// Lives at the composition root and is passed to `FlaggedReminderContent.make`.
/// Held as a strong reference by `main.swift` — NSMenuItem.target is weak.
final class ReminderItemActionHandler: NSObject {
    @objc func openReminder(_ sender: Any?) {
        guard
            let item = sender as? NSMenuItem,
            let id = item.representedObject as? String
        else { return }
        Self.open(reminderId: id)
    }

    private static func open(reminderId: String) {
        let source = """
        tell application "Reminders"
            set theReminder to first reminder whose id is "\(reminderId)"
            show theReminder
            activate
        end tell
        """
        guard let script = NSAppleScript(source: source) else { return }
        var error: NSDictionary?
        script.executeAndReturnError(&error)
    }
}
