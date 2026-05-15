/// A message read from Apple Mail. The filter that produced it (flagged today, others tomorrow)
/// is the reader's concern, not the entity's.
///
/// `id` is Mail's internal scripting id (an integer). It survives across app launches and is
/// what `tell application "Mail" to … whose id is N` uses to round-trip back to the message.
struct MailMessage: Equatable {
    let id: Int
    let subject: String
}
