default: run

run:
    swift run Mackasten

build:
    swift build

fmt:
    nix develop -c swiftformat .

clean:
    swift package clean
