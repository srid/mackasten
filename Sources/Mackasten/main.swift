import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

MenuBar.install()

app.run()
