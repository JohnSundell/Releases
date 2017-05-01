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
    /// The minor version of the release (0 if missing)
    public var minor = 0
    /// The patch version of the release (0 if missing)
    public var patch = 0
    /// Any prefix before the release's semantic version number (such as "v")
    public var prefix: String?
    /// Any suffix after the release's semantic version number (such as "-beta")
    public var suffix: String?

    fileprivate var componentCount = 1

    /// Initialize an instace with given version components
    public init(major: Int,
                minor: Int? = nil,
                patch: Int? = nil,
                prefix: String? = nil,
                suffix: String? = nil) {
        self.major = major

        if let minor = minor {
            self.minor = minor
            componentCount += 1
        }

        if let patch = patch {
            self.patch = patch
            componentCount += 1
        }

        self.prefix = prefix
        self.suffix = suffix
    }
}

/// Extension containg APIs for working with strings and versions
public extension Version {
    /// Convert the version into a string (Equivalent of "\(version)")
    var string: String {
        var string = (prefix ?? "") + String(major)

        if componentCount > 1 {
            string.append(".\(minor)")
        }

        if componentCount > 2 {
            string.append(".\(patch)")
        }

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

        let components = string.components(separatedBy: ".")
        let firstComponent = components[0]

        major = try parse(component: firstComponent)

        let majorString = String(major)
        let majorStringLength = majorString.distance(from: majorString.startIndex,
                                                     to: majorString.endIndex)

        let prefixEndIndex = firstComponent.index(firstComponent.endIndex, offsetBy: -majorStringLength)
        let prefixString = firstComponent.substring(to: prefixEndIndex)

        if prefixString.characters.count > 0 {
            prefix = prefixString
        }

        var parsedString = prefixString + majorString

        if components.count > 1 {
            minor = try parse(component: components[1])
            componentCount += 1
            parsedString.append(".\(minor)")
        }

        if components.count > 2 {
            patch = try parse(component: components[2])
            componentCount += 1
            parsedString.append(".\(patch)")
        }

        let suffixComponents = string.components(separatedBy: parsedString)

        if suffixComponents.count > 1 {
            if let lastSuffixComponent = suffixComponents.last {
                if !lastSuffixComponent.isEmpty {
                    if lastSuffixComponent != "^{}" {
                        suffix = lastSuffixComponent
                    }
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
