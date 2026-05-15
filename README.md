# Mackasten

A macOS menubar app for task management that lives alongside the Apple productivity apps you already use — Mail, Reminders, Calendar, and friends.

> Status: bootstrap. The current build wires up the menubar with a "Hello World" entry. Integration with Mail / Reminders / Calendar comes in subsequent iterations.

## Run

```sh
swift run Mackasten
```

A `checklist` icon appears in the macOS menubar. Click it to see the menu and quit.

## Development

The repo provides a Nix flake exposing the dev tooling. Enter the shell with:

```sh
nix develop
```

This puts `swiftformat` on your `PATH`. Format the codebase:

```sh
swiftformat .
```

Run the test suite:

```sh
swift test
```

## Project layout

- `Sources/Mackasten/main.swift` — process entry point. Sets the activation policy to `.accessory` (no Dock icon) and installs the menubar item.
- `Sources/Mackasten/MenuBar.swift` — menubar wiring (icon, menu, quit action).
- `Tests/MackastenTests/` — unit tests for the menubar configuration.
- `flake.nix` — Nix devShell.
