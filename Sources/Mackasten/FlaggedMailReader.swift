import Foundation

/// Reads flagged messages from Apple Mail via AppleScript. Returns an empty list on any failure
/// (Mail not installed, Automation permission denied, no flagged messages).
///
/// Calling this triggers a macOS Automation permission prompt the first time the app runs.
enum FlaggedMailReader {
    private static let script = """
    tell application "Mail"
        set output to ""
        set theMessages to (every message of inbox whose flagged status is true)
        repeat with msg in theMessages
            set output to output & (subject of msg) & linefeed
        end repeat
        return output
    end tell
    """

    static func read() -> [FlaggedMail] {
        guard let appleScript = NSAppleScript(source: script) else { return [] }
        var error: NSDictionary?
        let result = appleScript.executeAndReturnError(&error)
        guard error == nil, let raw = result.stringValue else { return [] }
        return raw
            .split(whereSeparator: \.isNewline)
            .map { FlaggedMail(subject: String($0)) }
    }
}
