// swift-tools-version:4.0

/**
 *  Releases
 *  Copyright (c) John Sundell 2017
 *  Licensed under the MIT license. See LICENSE file.
 */

import PackageDescription

let package = Package(
    name: "Releases",
    products: [
        .library(name: "Releases", targets: ["Releases"])
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
        .package(url: "https://github.com/JohnSundell/Require.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "Releases",
            dependencies: ["ShellOut", "Require"],
            path: "Sources"
        ),
        .testTarget(
            name: "ReleasesTests",
            dependencies: ["Releases"]
        )
    ]
)
