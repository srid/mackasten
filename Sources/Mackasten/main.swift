import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let quit = NSMenuItem(
    title: "Quit",
    action: #selector(NSApplication.terminate(_:)),
    keyEquivalent: "q"
)

let mails = MailReader.read().items
let reminders = ReminderReader.read().items

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

let mailRows = FlaggedMailContent.menuItems(from: mails, onSelect: mailOnSelect)
let reminderRows = FlaggedReminderContent.menuItems(from: reminders, onSelect: reminderOnSelect)
let menuItems = mailRows + [.separator()] + reminderRows + [.separator(), quit]

MenuBar.install(MenuBarContent(
    symbolName: "flag",
    accessibilityDescription: "Mackasten — Items requiring focus",
    menuItems: menuItems
))

app.run()
