// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SYButton",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "SYButton", targets: ["SYButton"]),
    ],
    targets: [
        .target(name: "SYButton", path: "Sources"),
        .testTarget(name: "SYButtonTests", dependencies: ["SYButton"]),
    ],
    swiftLanguageVersions: [.v5]
)
