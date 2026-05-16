import Foundation

/// Which subset of reminders to read. Today only flagged-and-incomplete is wired
/// through (the analogue of flagged Mail); additional cases (due today, priority,
/// specific lists) land as their AppleScript predicates are written.
enum ReminderFilter {
    case flaggedIncomplete

    var appleScriptPredicate: String {
        switch self {
        case .flaggedIncomplete: return "flagged is true and completed is false"
        }
    }
}

/// Reads items from Apple Reminders via AppleScript, filtered by `ReminderFilter`.
/// Calling this triggers a macOS Automation permission prompt the first time the app
/// runs; denying it surfaces here as `.scriptFailed`.
enum ReminderReader {
    static func read(filter: ReminderFilter = .flaggedIncomplete) -> AppReadResult<ReminderItem> {
        // Reminders' top-level `reminders` collection can be unreliable across
        // accounts/lists, so iterate `lists` explicitly. Each row is a 2-element
        // AppleScript list {id, name}; on the Swift side every top-level descriptor
        // is itself a list descriptor, walked via `atIndex(_:)` (1-based per AE).
        let source = """
        tell application "Reminders"
            set output to {}
            repeat with theList in lists
                repeat with r in (reminders of theList whose \(filter.appleScriptPredicate))
                    set end of output to {id of r, name of r}
                end repeat
            end repeat
            return output
        end tell
        """
        guard let appleScript = NSAppleScript(source: source) else { return .appNotInstalled }
        var error: NSDictionary?
        let result = appleScript.executeAndReturnError(&error)
        guard error == nil else { return .scriptFailed }
        let reminders: [ReminderItem] = AppleScriptResultParser.parseRows(result) { row in
            guard
                let id = row.atIndex(1)?.stringValue,
                let title = row.atIndex(2)?.stringValue
            else { return nil }
            return ReminderItem(id: id, title: title)
        }
        return .success(reminders)
    }
}
