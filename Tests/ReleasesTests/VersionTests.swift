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
        XCTAssertEqual(version.string, "1.2.5-beta")
    }

    func testParsingVersionWithPointSuffix() throws {
        let version = try Version(string: "1.2.5.alpha")

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 5)
        XCTAssertEqual(version.suffix, ".alpha")
        XCTAssertEqual(version.string, "1.2.5.alpha")
    }

    func testParsingVersionWithPrefix() throws {
        let version = try Version(string: "v3.2.1")

        XCTAssertEqual(version.prefix, "v")
        XCTAssertEqual(version.major, 3)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 1)
        XCTAssertNil(version.suffix)
        XCTAssertEqual(version.string, "v3.2.1")
    }

    func testParsingVersionWithUnwantedSuffix() throws {
        let version = try Version(string: "3.0.6^{}")

        XCTAssertEqual(version.major, 3)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 6)
        XCTAssertNil(version.suffix)
    }

    func testOriginalStringIntact() throws {
        let singleComponentVersion = try Version(string: "4")
        XCTAssertEqual(singleComponentVersion.major, 4)
        XCTAssertEqual(singleComponentVersion.string, "4")

        let dualComponentVersion = try Version(string: "3.0")
        XCTAssertEqual(dualComponentVersion.major, 3)
        XCTAssertEqual(dualComponentVersion.minor, 0)
        XCTAssertEqual(dualComponentVersion.string, "3.0")

        let dualComponentVersionWithPrefixAndSuffix = try Version(string: "v5.1beta")
        XCTAssertEqual(dualComponentVersionWithPrefixAndSuffix.major, 5)
        XCTAssertEqual(dualComponentVersionWithPrefixAndSuffix.minor, 1)
        XCTAssertEqual(dualComponentVersionWithPrefixAndSuffix.prefix, "v")
        XCTAssertEqual(dualComponentVersionWithPrefixAndSuffix.suffix, "beta")
        XCTAssertEqual(dualComponentVersionWithPrefixAndSuffix.string, "v5.1beta")
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

extension VersionTests {
    static var allTests: [(String, (VersionTests) -> () throws -> Void)] {
        return [
            ("testParsingVersionWithOnlyMajorComponent", testParsingVersionWithOnlyMajorComponent),
            ("testParsingVersionWithMinorComponent", testParsingVersionWithMinorComponent),
            ("testParsingVersionWithPatchComponent", testParsingVersionWithPatchComponent),
            ("testParsingVersionWithDashSuffix", testParsingVersionWithDashSuffix),
            ("testParsingVersionWithPointSuffix", testParsingVersionWithPointSuffix),
            ("testParsingVersionWithPrefix", testParsingVersionWithPrefix),
            ("testParsingVersionWithUnwantedSuffix", testParsingVersionWithUnwantedSuffix),
            ("testOriginalStringIntact", testOriginalStringIntact),
            ("testParsingEmptyStringThrows", testParsingEmptyStringThrows),
            ("testParsingMumboJumboThrows", testParsingMumboJumboThrows),
            ("testParsingVersionWithInvalidComponentThrows", testParsingVersionWithInvalidComponentThrows),
            ("testSorting", testSorting)
        ]
    }
}
