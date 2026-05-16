# Mackasten

A macOS menubar app for task management that lives alongside the Apple productivity apps you already use — Mail, Reminders, Calendar, and friends.

> Status: bootstrap. A single menubar item shows flagged messages from Apple Mail and flagged-incomplete reminders from Apple Reminders, with per-row icons distinguishing the two. Calendar integration comes in a subsequent iteration.

## Run

```sh
just run
```

A single `flag` icon appears in the macOS menubar. Clicking it opens a unified menu that lists:

- every flagged message in your unified inbox (rows prefixed with an envelope icon), or "No flagged mail" when empty,
- a separator,
- every reminder that's flagged and not yet completed (rows prefixed with a circle icon), or "No reminders requiring focus" when empty,
- a separator,
- Quit.

Clicking a row opens the message / reminder in its source app.

The first run prompts for **Automation** permission to script `Mail.app` and `Reminders.app` — accept both so Mackasten can read your flagged items. Without permission, the corresponding section shows its empty placeholder regardless of state. SPM executables ship without an `Info.plist`, so the prompt text is generic; the requesting app is `Mackasten`.

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

`Tests/MackastenTests/` covers `SourceAppContent` (the generic pure builder that turns any `[SourceAppItem]` into NSMenuItem rows, covering Mail and Reminders inputs in the empty / populated / wired-on-select cases) and `MenuBar.install` (the configured `NSStatusItem` reflects the input content). The AppleScript boundaries in `MailReader` and `ReminderReader` are not unit-tested — they require live `Mail.app` / `Reminders.app`. XCTest is bundled with full Xcode — CommandLineTools alone is insufficient.

## Project layout

- `Sources/Mackasten/main.swift` — composition root. Sets `.accessory` activation policy, calls `MailReader.read()` and `ReminderReader.read()`, asks each content builder for its rows, splices them together with separators and a Quit footer, and installs the resulting `MenuBarContent` on the single status item.
- `Sources/Mackasten/MenuBar.swift` — AppKit wiring: builds the `NSStatusItem`, attaches the menu, retains the item internally.
- `Sources/Mackasten/MenuBarContent.swift` — pure-data type describing what to put on the menubar (icon symbol, accessibility description, menu items).
- `Sources/Mackasten/MenuItemAction.swift` — `(target, selector)` couplet shared by mail and reminder content builders.
- `Sources/Mackasten/MenuRow.swift` — shared helpers: SF Symbol icons for rows and the disabled placeholder.
- `Sources/Mackasten/MailMessage.swift` — a message read from Mail (subject only, for now).
- `Sources/Mackasten/MailReader.swift` — AppleScript boundary. Iterates the unified inbox, returns a `MailReadResult` (`success([MailMessage])`, `mailNotInstalled`, `scriptFailed`). Takes a `MailFilter` parameter — only `.flagged` is wired today.
- `Sources/Mackasten/MailItemActionHandler.swift` — AppKit target that opens a Mail message by id via AppleScript when its menu item is clicked.
- `Sources/Mackasten/SourceAppItem.swift` — protocol every menu-row source (Mail, Reminders, future Calendar) conforms to, exposing a `displayLabel` and `menuId: String`.
- `Sources/Mackasten/SourceAppContent.swift` — generic pure builder turning `[T: SourceAppItem]` plus an icon name and empty-state copy into `[NSMenuItem]` rows.
- `Sources/Mackasten/ReminderItem.swift` — a reminder read from Reminders (id + title).
- `Sources/Mackasten/ReminderReader.swift` — AppleScript boundary. Iterates every Reminders list, returns a `ReminderReadResult` (`success([ReminderItem])`, `remindersNotInstalled`, `scriptFailed`). Takes a `ReminderFilter` parameter — only `.flaggedIncomplete` is wired today.
- `Sources/Mackasten/ReminderItemActionHandler.swift` — AppKit target that opens a Reminder by id via AppleScript when its menu item is clicked.
- `justfile` — common dev recipes (`run`, `build`, `fmt`, `clean`).
- `flake.nix` — Nix devShell (`swiftformat`).

## License

[AGPL-3.0](LICENSE).
