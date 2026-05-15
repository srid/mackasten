// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Mackasten",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(name: "Mackasten", path: "Sources/Mackasten"),
        .testTarget(
            name: "MackastenTests",
            dependencies: ["Mackasten"],
            path: "Tests/MackastenTests"
        ),
    ]
)
