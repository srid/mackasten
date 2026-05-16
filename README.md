# Mackasten

A macOS menubar app for task management that lives alongside the Apple productivity apps you already use — Mail, Reminders, Calendar, and friends.

> Status: bootstrap. The menubar shows flagged messages from Apple Mail and flagged-incomplete reminders from Apple Reminders. Calendar integration comes in a subsequent iteration.

## Run

```sh
just run
```

Two icons appear in the macOS menubar:

- A `flag` icon — click it to see the subjects of every flagged message in your unified inbox (or "No flagged mail" if there are none), plus a Quit item.
- A `checklist` icon — click it to see the titles of every reminder that's flagged and not yet completed (or "No reminders requiring focus" if there are none).

Clicking a row in either menu opens the message / reminder in its source app.

The first run prompts for **Automation** permission to script `Mail.app` and `Reminders.app` — accept both so Mackasten can read your flagged items. Without permission, each menu shows its empty placeholder regardless of state. SPM executables ship without an `Info.plist`, so the prompt text is generic; the requesting app is `Mackasten`.

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

`Tests/MackastenTests/` covers `FlaggedMailContent` and `FlaggedReminderContent` (the pure builders that turn a list of items into menu items, in the empty / populated / with-footer cases) and `MenuBar.install` (each `NSStatusItem` reflects its input content, single- and multi-content modes). The AppleScript boundaries in `MailReader` and `ReminderReader` are not unit-tested — they require live `Mail.app` / `Reminders.app`. XCTest is bundled with full Xcode — CommandLineTools alone is insufficient.

## Project layout

- `Sources/Mackasten/main.swift` — composition root. Sets `.accessory` activation policy, calls `MailReader.read()` and `ReminderReader.read()`, builds the Quit footer, hands each list to its content builder, and installs the menubar with both contents.
- `Sources/Mackasten/MenuBar.swift` — AppKit wiring: builds one `NSStatusItem` per `MenuBarContent`, attaches each menu, retains the items internally.
- `Sources/Mackasten/MenuBarContent.swift` — pure-data type describing what to put on a single menubar slot (icon symbol, accessibility description, menu items).
- `Sources/Mackasten/MenuItemAction.swift` — `(target, selector)` couplet shared by mail and reminder content builders.
- `Sources/Mackasten/MailMessage.swift` — a message read from Mail (subject only, for now).
- `Sources/Mackasten/MailReader.swift` — AppleScript boundary. Iterates the unified inbox, returns a `MailReadResult` (`success([MailMessage])`, `mailNotInstalled`, `scriptFailed`). Takes a `MailFilter` parameter — only `.flagged` is wired today.
- `Sources/Mackasten/MailItemActionHandler.swift` — AppKit target that opens a Mail message by id via AppleScript when its menu item is clicked.
- `Sources/Mackasten/FlaggedMailContent.swift` — pure builder turning `[MailMessage] + footer` into a `MenuBarContent`. Renders a "No flagged mail" placeholder when the list is empty.
- `Sources/Mackasten/ReminderItem.swift` — a reminder read from Reminders (id + title).
- `Sources/Mackasten/ReminderReader.swift` — AppleScript boundary. Iterates every Reminders list, returns a `ReminderReadResult` (`success([ReminderItem])`, `remindersNotInstalled`, `scriptFailed`). Takes a `ReminderFilter` parameter — only `.flaggedIncomplete` is wired today.
- `Sources/Mackasten/ReminderItemActionHandler.swift` — AppKit target that opens a Reminder by id via AppleScript when its menu item is clicked.
- `Sources/Mackasten/FlaggedReminderContent.swift` — pure builder turning `[ReminderItem] + footer` into a `MenuBarContent`. Renders a "No reminders requiring focus" placeholder when the list is empty.
- `justfile` — common dev recipes (`run`, `build`, `fmt`, `clean`).
- `flake.nix` — Nix devShell (`swiftformat`).

## License

[AGPL-3.0](LICENSE).
