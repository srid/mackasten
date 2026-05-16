/// A reminder read from Apple Reminders. The filter that produced it (flagged today,
/// others tomorrow) is the reader's concern, not the entity's.
///
/// `id` is Reminders' scripting id — a URL-style string (e.g.
/// `x-apple-reminderkit://REMCDReminder/UUID`). Treat it as opaque; it is what
/// `tell application "Reminders" to … whose id is "…"` uses to round-trip.
struct ReminderItem: Equatable {
    let id: String
    let title: String
}
