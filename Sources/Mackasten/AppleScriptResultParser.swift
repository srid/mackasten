import Foundation

/// Walks an `NSAppleEventDescriptor` returned by NSAppleScript and rebuilds it as a
/// `[T]` via a per-row constructor. Owns the 1-based AE iteration so each reader
/// keeps column semantics local without re-implementing the descriptor mechanics.
enum AppleScriptResultParser {
    static func parseRows<T>(
        _ descriptor: NSAppleEventDescriptor,
        _ build: (NSAppleEventDescriptor) -> T?
    ) -> [T] {
        let count = descriptor.numberOfItems
        guard count > 0 else { return [] }
        return (1 ... count).compactMap { index in
            guard let row = descriptor.atIndex(index) else { return nil }
            return build(row)
        }
    }
}
