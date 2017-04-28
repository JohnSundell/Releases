/**
 *  Releases
 *  Copyright (c) John Sundell 2017
 *  Licensed under the MIT license. See LICENSE file.
 */

import XCTest
import Releases

class VersionTests: XCTestCase {
    func testParsingVersionWithOnlyMajorComponent() throws {
        let version = try Version(string: "1")

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertNil(version.suffix)
    }

    func testParsingVersionWithMinorComponent() throws {
        let version = try Version(string: "3.2")

        XCTAssertEqual(version.major, 3)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 0)
        XCTAssertNil(version.suffix)
    }

    func testParsingVersionWithPatchComponent() throws {
        let version = try Version(string: "4.1.9")

        XCTAssertEqual(version.major, 4)
        XCTAssertEqual(version.minor, 1)
        XCTAssertEqual(version.patch, 9)
        XCTAssertNil(version.suffix)
    }

    func testParsingVersionWithDashSuffix() throws {
        let version = try Version(string: "1.2.5-beta")

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 5)
        XCTAssertEqual(version.suffix, "-beta")
    }

    func testParsingVersionWithPointSuffix() throws {
        let version = try Version(string: "1.2.5.alpha")

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 5)
        XCTAssertEqual(version.suffix, ".alpha")
    }

    func testParsingVersionWithUnwantedSuffix() throws {
        let version = try Version(string: "3.0.6^{}")

        XCTAssertEqual(version.major, 3)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 6)
        XCTAssertNil(version.suffix)
    }

    func testParsingEmptyStringThrows() throws {
        let expectedError = Releases.Error.unrecognizedVersionComponentFormat("")
        assert(try Version(string: ""), throwsError: expectedError)
    }

    func testParsingMumboJumboThrows() throws {
        let expectedError = Releases.Error.unrecognizedVersionComponentFormat("Clearly not a version")
        assert(try Version(string: "Clearly not a version"), throwsError: expectedError)
    }

    func testParsingVersionWithInvalidComponentThrows() throws {
        let expectedError = Releases.Error.unrecognizedVersionComponentFormat("NaN")
        assert(try Version(string: "1.NaN.5"), throwsError: expectedError)
    }

    func testSorting() {
        let unsorted = [
            Version(major: 1, minor: 1, patch: 7),
            Version(major: 2),
            Version(major: 1, minor: 2),
            Version(major: 1)
        ]

        let expectedSorted = [
            Version(major: 1),
            Version(major: 1, minor: 1, patch: 7),
            Version(major: 1, minor: 2),
            Version(major: 2)
        ]

        XCTAssertEqual(unsorted.sorted(), expectedSorted)
    }
}
