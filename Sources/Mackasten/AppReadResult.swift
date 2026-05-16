/// The three states an AppleScript-backed reader can distinguish — NSAppleScript
/// surfaces no finer error discrimination (TCC denial vs compile error vs runtime
/// failure all land as `scriptFailed`). Generic over the item type so Mail and
/// Reminders share one shape.
///
/// `appNotInstalled` is a structural placeholder: in practice `NSAppleScript(source:)`
/// only returns nil for a nil/empty source string, not for a missing target app, so
/// real "Mail.app not installed" failures surface as `.scriptFailed`. The case is
/// kept so future readers with a richer install probe can populate it without
/// breaking the API.
enum AppReadResult<T> {
    case success([T])
    case appNotInstalled
    case scriptFailed
}

extension AppReadResult {
    /// The successful items, or an empty list when the underlying app is unavailable
    /// or the script failed — callers that just want "show what we can read" use this.
    var items: [T] {
        switch self {
        case let .success(items): return items
        case .appNotInstalled, .scriptFailed: return []
        }
    }
}
