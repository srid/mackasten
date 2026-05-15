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

/// The three states the AppleScript boundary can actually distinguish.
/// Finer error discrimination (TCC denial vs. compile error vs. arbitrary runtime
/// failure) is not available from NSAppleScript, so the enum stays at three cases.
enum MailReadResult {
    case success([MailMessage])
    case mailNotInstalled
    case scriptFailed
}

/// Reads messages from Apple Mail via AppleScript, filtered by `MailFilter`.
/// Calling this triggers a macOS Automation permission prompt the first time the app runs;
/// the prompt result surfaces here as `.scriptFailed` if the user denies it.
enum MailReader {
    static func read(filter: MailFilter = .flagged) -> MailReadResult {
        let source = """
        tell application "Mail"
            set output to {}
            repeat with acct in every account
                try
                    repeat with msg in (every message of inbox of acct whose \(filter.appleScriptPredicate))
                        set end of output to subject of msg
                    end repeat
                end try
            end repeat
            return output
        end tell
        """
        guard let appleScript = NSAppleScript(source: source) else { return .mailNotInstalled }
        var error: NSDictionary?
        let result = appleScript.executeAndReturnError(&error)
        guard error == nil else { return .scriptFailed }
        let count = result.numberOfItems
        let mails = count > 0
            ? (1 ... count).compactMap { result.atIndex($0)?.stringValue }.map { MailMessage(subject: $0) }
            : []
        return .success(mails)
    }
}
