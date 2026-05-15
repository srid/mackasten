/// A message read from Apple Mail. The filter that produced it (flagged today, others tomorrow)
/// is the reader's concern, not the entity's.
struct MailMessage: Equatable {
    let subject: String
}
