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

let mailActionHandler = MailItemActionHandler()
let onSelect = MailItemAction(
    target: mailActionHandler,
    selector: #selector(MailItemActionHandler.openMessage(_:))
)

MenuBar.install(FlaggedMailContent.make(from: mails, onSelect: onSelect, footer: footer))

app.run()
