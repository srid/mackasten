import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

MenuBar.install(HelloWorldContent.make())

app.run()
