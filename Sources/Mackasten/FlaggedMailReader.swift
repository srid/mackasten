import Foundation

/// Reads flagged messages from Apple Mail via AppleScript. Returns an empty list on any failure
/// (Mail not installed, Automation permission denied, no flagged messages).
///
/// Calling this triggers a macOS Automation permission prompt the first time the app runs.
enum FlaggedMailReader {
    private static let script = """
    tell application "Mail"
        set output to {}
        repeat with msg in (every message of inbox whose flagged status is true)
            set end of output to subject of msg
        end repeat
        return output
    end tell
    """

    static func read() -> [FlaggedMail] {
        guard let appleScript = NSAppleScript(source: script) else { return [] }
        var error: NSDictionary?
        let result = appleScript.executeAndReturnError(&error)
        guard error == nil else { return [] }
        let count = result.numberOfItems
        guard count > 0 else { return [] }
        var mails: [FlaggedMail] = []
        for index in 1 ... count {
            if let subject = result.atIndex(index)?.stringValue {
                mails.append(FlaggedMail(subject: subject))
            }
        }
        return mails
    }
}
