# Build and run the app (default).
default: run

# Build and run the menubar app.
run:
    swift run Mackasten

# Compile without running.
build:
    swift build

# Format Swift sources via swiftformat (provided by the Nix devShell).
fmt:
    nix develop -c swiftformat .

# Remove SwiftPM build artifacts.
clean:
    swift package clean
