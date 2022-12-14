// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ControlCommands",
    platforms: [.macOS(.v11), .iOS(.v15), .macCatalyst(.v15)],
    products: [
        .library(
            name: "ControlCommands",
            targets: ["ControlCommands"]),
    ],
    targets: [
        .target(
            name: "ControlCommands",
            dependencies: []),
        .testTarget(
            name: "ControlCommandsTests",
            dependencies: ["ControlCommands"]),
    ]
)
