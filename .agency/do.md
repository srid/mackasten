# /do config

## Check command
swift build

## Format command
nix develop -c swiftformat .

## Test command
swift test

## CI command
swift build && swift test

## Documentation
Keep `README.md` in sync with user-facing changes.
