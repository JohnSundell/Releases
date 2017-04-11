/**
 *  Releases
 *  Copyright (c) John Sundell 2017
 *  Licensed under the MIT license. See LICENSE file.
 */

import Foundation

/// Structure representing a released version
public struct Version {
    /// The major version of the release
    public var major: Int
    // The minor version of the release (0 if missing)
    public var minor: Int
    // The patch version of the release (0 if missing)
    public var patch: Int
    // Any suffix after the release's semantic version number (such as "-beta")
    public var suffix: String?

    /// Initialize an instace with given version components
    public init(major: Int, minor: Int = 0, patch: Int = 0, suffix: String? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.suffix = suffix
    }
}

/// Extension containg APIs for working with strings and versions
public extension Version {
    /// Convert the version into a string (Equivalent of "\(version)")
    var string: String {
        var string = "\(major).\(minor).\(patch)"

        if let suffix = suffix {
            string.append(suffix)
        }

        return string
    }

    /**
     *  Attempt to parse a string describing a version
     *
     *  - parameter string: The string to parse. Expected format: "major.minor.patch".
     *  - throws: `Releases.Error` if an error was encountered
     */
    init(string: String) throws {
        major = 0
        minor = 0
        patch = 0

        let components = string.components(separatedBy: ".")

        major = try parse(component: components[0])
        var parsedString = "\(major)"

        if components.count > 1 {
            minor = try parse(component: components[1])
            parsedString.append(".\(minor)")
        }

        if components.count > 2 {
            patch = try parse(component: components[2])
            parsedString.append(".\(patch)")
        }

        let suffixComponents = string.components(separatedBy: parsedString)

        if suffixComponents.count > 1 {
            if let lastSuffixComponent = suffixComponents.last {
                if !lastSuffixComponent.isEmpty {
                    suffix = lastSuffixComponent
                }
            }
        }
    }
}

// MARK: - Protocol conformances

extension Version: Equatable {
    public static func ==(lhs: Version, rhs: Version) -> Bool {
        guard lhs.major == rhs.major else {
            return false
        }

        guard lhs.minor == rhs.minor else {
            return false
        }

        guard lhs.patch == rhs.patch else {
            return false
        }

        return lhs.suffix == rhs.suffix
    }
}

extension Version: Comparable {
    public static func <(lhs: Version, rhs: Version) -> Bool {
        guard lhs.major == rhs.major else {
            return lhs.major < rhs.major
        }

        guard lhs.minor == rhs.minor else {
            return lhs.minor < rhs.minor
        }

        return lhs.patch < rhs.patch
    }
}

extension Version: CustomStringConvertible {
    public var description: String {
        return string
    }
}

// MARK: - Private

private extension Version {
    private enum ParsingDirection {
        case leading
        case trailing
    }

    func parse(component: String) throws -> Int {
        if let number = parse(component: component, direction: .leading) {
            return number
        }

        guard let number = parse(component: component, direction: .trailing) else {
            throw Releases.Error.unrecognizedVersionComponentFormat(component)
        }

        return number
    }

    private func parse(component: String, direction: ParsingDirection) -> Int? {
        var component = component
        var number = Int(component)

        while number == nil && component.characters.count > 0 {
            switch direction {
            case .leading:
                component.remove(at: component.startIndex)
            case .trailing:
                let lastCharacterIndex = component.index(before: component.endIndex)
                component.remove(at: lastCharacterIndex)
            }

            number = Int(component)
        }

        return number
    }
}
