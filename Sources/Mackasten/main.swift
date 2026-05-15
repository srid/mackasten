import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

MenuBar.install(FlaggedMailContent.make(from: FlaggedMailReader.read()))

app.run()
