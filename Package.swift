// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
    ],
    targets: [
        .target(
            name: "Core",
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Core"],
            path: "Tests"),
    ]
)
