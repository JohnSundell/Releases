/**
 *  Releases
 *  Copyright (c) John Sundell 2017
 *  Licensed under the MIT license. See LICENSE file.
 */

import XCTest
import Releases
import ShellOut
import Require

class ReleasesTests: XCTestCase {
    var folderPath: String!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        folderPath = NSTemporaryDirectory() + "ReleasesTests"

        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: folderPath)
        try! fileManager.createDirectory(atPath: folderPath,
                                         withIntermediateDirectories: false,
                                         attributes: nil)
    }

    override func tearDown() {
        try! FileManager.default.removeItem(atPath: folderPath)
        super.tearDown()
    }

    // MARK: - Tests

    func testResolvingVersionsForRemoteRepository() throws {
        let url = URL(string: "git@github.com:johnsundell/unbox.git").require()
        let versions = try Releases.versions(for: url)

        // We don't want to make any assumptions about future versions
        // of Unbox, but we can make verifications against the past
        XCTAssertEqual(versions[0], Version(major: 1))
        XCTAssertEqual(versions[1], Version(major: 1, minor: 1))
        XCTAssertEqual(versions[2], Version(major: 1, minor: 2))
        XCTAssertEqual(versions[3], Version(major: 1, minor: 2, patch: 1))
    }

    func testResolvingVersionsForLocalRepository() throws {
        let repositoryCommands = [
            "git init",
            "swift package init",
            "git add .",
            "git commit -m \"Commit A\"",
            "git tag 1.0.0",
            "echo Hello > FileA",
            "git add FileA",
            "git commit -m \"Commit B\"",
            "git tag 1.1.0",
            "echo Beta > FileB",
            "git add FileB",
            "git commit -m \"Commit C\"",
            "git tag 2.0-beta"
        ]
        
        try shellOut(to: repositoryCommands, at: folderPath)

        let url = URL(fileURLWithPath: folderPath)
        let versions = try Releases.versions(for: url)

        XCTAssertEqual(versions.count, 3)
        XCTAssertEqual(versions[0], Version(major: 1))
        XCTAssertEqual(versions[1], Version(major: 1, minor: 1))
        XCTAssertEqual(versions[2], Version(major: 2, suffix: "-beta"))

        // Test excluding beta version
        let lastStableVersion = versions.withoutPreReleases().last.require()
        XCTAssertEqual(lastStableVersion, Version(major: 1, minor: 1))
    }
}

extension ReleasesTests {
    static var allTests: [(String, (ReleasesTests) -> () throws -> Void)] {
        return [
            ("testInvalidCommandThrows", testResolvingVersionsForRemoteRepository),
            ("testInvalidCommandThrows", testResolvingVersionsForLocalRepository)
        ]
    }
}
