import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let quit = NSMenuItem(
    title: "Quit",
    action: #selector(NSApplication.terminate(_:)),
    keyEquivalent: "q"
)
let footer: [NSMenuItem] = [.separator(), quit]

let mails: [MailMessage]
switch MailReader.read() {
case let .success(messages):
    mails = messages
case .mailNotInstalled, .scriptFailed:
    mails = []
}

let reminders: [ReminderItem]
switch ReminderReader.read() {
case let .success(items):
    reminders = items
case .remindersNotInstalled, .scriptFailed:
    reminders = []
}

let mailActionHandler = MailItemActionHandler()
let mailOnSelect = MenuItemAction(
    target: mailActionHandler,
    selector: #selector(MailItemActionHandler.openMessage(_:))
)

let reminderActionHandler = ReminderItemActionHandler()
let reminderOnSelect = MenuItemAction(
    target: reminderActionHandler,
    selector: #selector(ReminderItemActionHandler.openReminder(_:))
)

// Quit lives on the mail menu only — duplicating it on both menus would clutter
// the UI without adding discoverability.
MenuBar.install([
    FlaggedMailContent.make(from: mails, onSelect: mailOnSelect, footer: footer),
    FlaggedReminderContent.make(from: reminders, onSelect: reminderOnSelect),
])

app.run()
