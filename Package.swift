/**
 *  Releases
 *  Copyright (c) John Sundell 2017
 *  Licensed under the MIT license. See LICENSE file.
 */

import PackageDescription

let package = Package(
    name: "Releases",
    dependencies: [
        .Package(url: "https://github.com/JohnSundell/ShellOut.git", majorVersion: 1),
        .Package(url: "https://github.com/JohnSundell/Require.git", majorVersion: 1)
    ]
)
