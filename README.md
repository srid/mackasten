# Mackasten

A macOS menubar app for task management that lives alongside the Apple productivity apps you already use — Mail, Reminders, Calendar, and friends.

> Status: bootstrap. The current build wires up the menubar with a "Hello World" entry. Integration with Mail / Reminders / Calendar comes in subsequent iterations.

## Run

```sh
just run
```

A `checklist` icon appears in the macOS menubar. Click it to see the menu and quit.

The plain Swift commands also work:

```sh
swift run Mackasten   # same as: just run
swift build           # same as: just build
```

## Format

```sh
just fmt
```

`just fmt` shells out to `nix develop -c swiftformat .`, so it does not require `swiftformat` to be installed globally — the Nix flake provides it.

## Tests

`swift test` requires the XCTest framework, which on macOS ships only with full Xcode (not CommandLineTools). Once Xcode is on `PATH` (`xcode-select -p` points at `/Applications/Xcode.app/Contents/Developer`), a test target will be reinstated.

## Project layout

- `Sources/Mackasten/main.swift` — process entry point. Sets the activation policy to `.accessory` (no Dock icon) and installs the menubar.
- `Sources/Mackasten/MenuBar.swift` — AppKit wiring: builds the `NSStatusItem`, attaches the menu, retains the item internally.
- `Sources/Mackasten/MenuBarContent.swift` — pure-data type describing what to put on the menubar (icon symbol, accessibility description, menu items).
- `Sources/Mackasten/HelloWorldContent.swift` — placeholder content. This is the seam where Mail / Reminders / Calendar integrations will land.
- `justfile` — common dev recipes (`run`, `build`, `fmt`, `clean`).
- `flake.nix` — Nix devShell (`swiftformat`).
