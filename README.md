# Mackasten

A macOS menubar app for task management that lives alongside the Apple productivity apps you already use — Mail, Reminders, Calendar, and friends.

> Status: bootstrap. The menubar shows flagged messages from Apple Mail. Reminders / Calendar integrations come in subsequent iterations.

## Run

```sh
just run
```

A `flag` icon appears in the macOS menubar. Click it to see the subjects of every flagged message in your unified inbox (or "No flagged mail" if there are none), plus a Quit item.

The first run prompts for **Automation** permission to script `Mail.app` — accept it so Mackasten can read your flagged messages. Without the permission, the menu shows "No flagged mail" regardless of state. SPM executables ship without an `Info.plist`, so the prompt text is generic; the requesting app is `Mackasten`.

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

```sh
swift test
```

`Tests/MackastenTests/` covers `FlaggedMailContent` (the pure builder that turns a list of flagged mails into menu items, in both the empty and populated cases) and `MenuBar.install` (the configured `NSStatusItem` reflects the input content). The AppleScript boundary in `FlaggedMailReader` is not unit-tested — it requires a live `Mail.app`. XCTest is bundled with full Xcode — CommandLineTools alone is insufficient.

## Project layout

- `Sources/Mackasten/main.swift` — process entry point. Sets the activation policy to `.accessory` (no Dock icon), reads flagged mail, and installs the menubar.
- `Sources/Mackasten/MenuBar.swift` — AppKit wiring: builds the `NSStatusItem`, attaches the menu, retains the item internally.
- `Sources/Mackasten/MenuBarContent.swift` — pure-data type describing what to put on the menubar (icon symbol, accessibility description, menu items).
- `Sources/Mackasten/FlaggedMail.swift` — a flagged message read from Mail (subject only, for now).
- `Sources/Mackasten/FlaggedMailReader.swift` — AppleScript boundary. Calls `Mail.app` for messages in the unified inbox with `flagged status is true`. Returns `[]` on any failure.
- `Sources/Mackasten/FlaggedMailContent.swift` — pure builder turning `[FlaggedMail]` into a `MenuBarContent`. Renders an "No flagged mail" placeholder when the list is empty.
- `justfile` — common dev recipes (`run`, `build`, `fmt`, `clean`).
- `flake.nix` — Nix devShell (`swiftformat`).

## License

[AGPL-3.0](LICENSE).
