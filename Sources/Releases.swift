/**
 *  Releases
 *  Copyright (c) John Sundell 2017
 *  Licensed under the MIT license. See LICENSE file.
 */

import Foundation
import ShellOut
import Require

/// Class providing an entry point to the Releases API
public class Releases {
    /**
     *  Resolve the released versions for a Git repository
     *
     *  - parameter url: The URL of the repository to resolve versions for
     *                   May either be a remote URL (with the '.git' suffix)
     *                   or a local URL/path.
     *
     *  - returns: An array of versions in the order they were tagged
     *  - throws: `Releases.Error` if an error was encountered
     */
    public static func versions(for url: URL) throws -> [Version] {
        let lines = try string(from: url).components(separatedBy: "\n")

        return try lines.compactMap { line in
            guard let tag = line.components(separatedBy: "refs/tags/").last else {
                throw Error.unrecognizedTagFormat(line)
            }

            return try? Version(string: tag)
        }
    }

    private static func string(from url: URL) throws -> String {
        do {
            if url.absoluteString.hasSuffix(".git") {
                return try shellOut(to: "git ls-remote --tags --sort=v:refname \(url.absoluteString)")
            } else {
                let path = url.absoluteString.replacingOccurrences(of: "file://", with: "")
                return try shellOut(to: "cd \"\(path)\" && git tag")
            }
        } catch {
            let error = (error as? ShellOutError).require(hint: "Incorrect error type")
            throw Error.gitLookupFailed(error.message)
        }
    }
}
