import Foundation

/// The three states the AppleScript boundary can actually distinguish.
/// Finer error discrimination (TCC denial vs. compile error vs. arbitrary runtime
/// failure) is not available from NSAppleScript, so the enum stays at three cases.
enum MailReadResult {
    case success([FlaggedMail])
    case mailNotInstalled
    case scriptFailed
}

/// Reads flagged messages from Apple Mail via AppleScript.
/// Calling this triggers a macOS Automation permission prompt the first time the app runs;
/// the prompt result surfaces here as `.scriptFailed` if the user denies it.
enum FlaggedMailReader {
    private static let script = """
    tell application "Mail"
        set output to {}
        repeat with acct in every account
            try
                repeat with msg in (every message of inbox of acct whose flagged status is true)
                    set end of output to subject of msg
                end repeat
            end try
        end repeat
        return output
    end tell
    """

    static func read() -> MailReadResult {
        guard let appleScript = NSAppleScript(source: script) else { return .mailNotInstalled }
        var error: NSDictionary?
        let result = appleScript.executeAndReturnError(&error)
        guard error == nil else { return .scriptFailed }
        let count = result.numberOfItems
        guard count > 0 else { return .success([]) }
        var mails: [FlaggedMail] = []
        for index in 1 ... count {
            if let subject = result.atIndex(index)?.stringValue {
                mails.append(FlaggedMail(subject: subject))
            }
        }
        return .success(mails)
    }
}
