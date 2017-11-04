import XCTest
@testable import ReleasesTests

XCTMain([
    testCase(ReleasesTests.allTests),
    testCase(VersionTests.allTests)
])
