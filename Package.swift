// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-playground",
    dependencies: [
       .package(url: "https://github.com/vapor/vapor.git", from: "3.3.0"),
       .package(url: "https://github.com/JohnSundell/Files.git", from: "2.3.0")
    ],
    targets: [
        .target(
            name: "swift-playground",
            dependencies: ["Vapor","Files"]),
        .testTarget(
            name: "swift-playgroundTests",
            dependencies: ["swift-playground"]),
    ]
)
