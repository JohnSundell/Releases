/**
 *  Releases
 *  Copyright (c) John Sundell 2017
 *  Licensed under the MIT license. See LICENSE file.
 */

import Foundation

public extension Releases {
    /// Error type used by Releases
    enum Error: Swift.Error {
        /// Thrown when tags could not be resolved for a given Git repository
        case gitLookupFailed(String)
        /// Thrown when a tag had an unrecognized format
        case unrecognizedTagFormat(String)
        /// Thrown when a version component had an unrecognized format
        case unrecognizedVersionComponentFormat(String)
    }
}

extension Releases.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .gitLookupFailed(let message):
            return "Failed to look up releases using Git. Error message: \(message)"
        case .unrecognizedTagFormat(let tag):
            return "Encountered a tag with an unrecognized format: '\(tag)'"
        case .unrecognizedVersionComponentFormat(let component):
            return "Encountered a version component with an unrecognized format: '\(component)'"
        }
    }
}

extension Releases.Error: Equatable {
    public static func ==(lhs: Releases.Error, rhs: Releases.Error) -> Bool {
        return lhs.description == rhs.description
    }
}
