import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let quit = NSMenuItem(
    title: "Quit",
    action: #selector(NSApplication.terminate(_:)),
    keyEquivalent: "q"
)
let footer: [NSMenuItem] = [.separator(), quit]

let mails: [FlaggedMail]
switch FlaggedMailReader.read() {
case let .success(messages):
    mails = messages
case .mailNotInstalled, .scriptFailed:
    mails = []
}

MenuBar.install(FlaggedMailContent.make(from: mails, footer: footer))

app.run()
