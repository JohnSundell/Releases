/**
 *  Releases
 *  Copyright (c) John Sundell 2017
 *  Licensed under the MIT license. See LICENSE file.
 */

import PackageDescription

let package = Package(
    name: "Releases",
    dependencies: [
        .Package(url: "https://github.com/johnsundell/shellout.git", majorVersion: 1),
        .Package(url: "https://github.com/johnsundell/require.git", majorVersion: 1)
    ]
)
