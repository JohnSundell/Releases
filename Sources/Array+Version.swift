/**
 *  Releases
 *  Copyright (c) John Sundell 2017
 *  Licensed under the MIT license. See LICENSE file.
 */

import Foundation

/// Extension for arrays containing versions
public extension Array where Element == Version {
    /// Filter this array to remove all pre-release versions, such as "alpha" & "beta"
    func withoutPreReleases() -> Array {
        let identifiers: [String] = ["alpha", "a", "beta", "b", "pre", "prerelease", "rc"]

        return filter { version in
            guard let suffix = version.suffix else {
                return true
            }

            for identifier in identifiers {
                if suffix.contains(identifier) {
                    return false
                }
            }

            return true
        }
    }
}
