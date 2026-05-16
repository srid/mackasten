/// The three states an AppleScript-backed reader can distinguish — NSAppleScript
/// surfaces no finer error discrimination (TCC denial vs compile error vs runtime
/// failure all land as `scriptFailed`). Generic over the item type so Mail and
/// Reminders share one shape.
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
