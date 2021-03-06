// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "createapp",
    platforms: [
        .macOS(.v10_11)
    ],
    products: [
        .executable(name: "createapp", targets: ["createapp"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "createapp",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "createappTests",
            dependencies: ["createapp"]
        ),
    ]
)
