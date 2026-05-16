import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let quit = NSMenuItem(
    title: "Quit",
    action: #selector(NSApplication.terminate(_:)),
    keyEquivalent: "q"
)

let mails: [MailMessage] = MailReader.read().items
let reminders: [ReminderItem] = ReminderReader.read().items

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

let mailRows = SourceAppContent.menuItems(
    from: mails,
    rowSymbolName: "envelope",
    emptyPlaceholder: "No flagged mail",
    onSelect: mailOnSelect
)
let reminderRows = SourceAppContent.menuItems(
    from: reminders,
    rowSymbolName: "circle",
    emptyPlaceholder: "No reminders requiring focus",
    onSelect: reminderOnSelect
)
let menuItems = mailRows + [.separator()] + reminderRows + [.separator(), quit]

MenuBar.install(MenuBarContent(
    symbolName: "flag",
    accessibilityDescription: "Mackasten — Items requiring focus",
    menuItems: menuItems
))

app.run()
