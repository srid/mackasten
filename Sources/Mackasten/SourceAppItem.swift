/// Anything Mackasten can show as a row in the unified focus menu: a Mail message,
/// a Reminder, eventually a Calendar event. The view layer needs a label and an id
/// to round-trip back through AppleScript — both are exposed as `String` so the
/// menu row machinery doesn't fork on the source-app's native id type.
protocol SourceAppItem {
    var displayLabel: String { get }
    var menuId: String { get }
}

extension MailMessage: SourceAppItem {
    var displayLabel: String {
        subject
    }

    var menuId: String {
        String(id)
    }
}

extension ReminderItem: SourceAppItem {
    var displayLabel: String {
        title
    }

    var menuId: String {
        id
    }
}
