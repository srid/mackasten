import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let quit = NSMenuItem(
    title: "Quit",
    action: #selector(NSApplication.terminate(_:)),
    keyEquivalent: "q"
)
let footer: [NSMenuItem] = [.separator(), quit]

MenuBar.install(FlaggedMailContent.make(from: FlaggedMailReader.read(), footer: footer))

app.run()
