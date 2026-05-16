import Foundation

/// Which subset of mail to read. Today only flagged is wired through; additional cases
/// (unread, important, today, VIP, ...) land as their AppleScript predicates are written.
enum MailFilter {
    case flagged

    var appleScriptPredicate: String {
        switch self {
        case .flagged: return "flagged status is true"
        }
    }
}

/// Reads messages from Apple Mail via AppleScript, filtered by `MailFilter`.
/// Calling this triggers a macOS Automation permission prompt the first time the app runs;
/// the prompt result surfaces here as `.scriptFailed` if the user denies it.
enum MailReader {
    static func read(filter: MailFilter = .flagged) -> AppReadResult<MailMessage> {
        // `inbox` at the top level is Mail's unified inbox — it spans every account
        // by definition. Per-account iteration (`inbox of acct`) is not a thing in
        // Mail's scripting suite; that path errors silently with -1728.
        // Each row in `output` is a 2-element AppleScript list {id, subject}; on the
        // Swift side every top-level descriptor is itself a list descriptor, walked
        // via `atIndex(_:)` (1-based per AE convention).
        let source = """
        tell application "Mail"
            set output to {}
            repeat with msg in (every message of inbox whose \(filter.appleScriptPredicate))
                set end of output to {id of msg, subject of msg}
            end repeat
            return output
        end tell
        """
        guard let appleScript = NSAppleScript(source: source) else { return .appNotInstalled }
        var error: NSDictionary?
        let result = appleScript.executeAndReturnError(&error)
        guard error == nil else { return .scriptFailed }
        let count = result.numberOfItems
        let mails: [MailMessage] = count > 0
            ? (1 ... count).compactMap { index in
                guard
                    let row = result.atIndex(index),
                    let subject = row.atIndex(2)?.stringValue
                else { return nil }
                return MailMessage(id: Int(row.atIndex(1)?.int32Value ?? 0), subject: subject)
            }
            : []
        return .success(mails)
    }
}
