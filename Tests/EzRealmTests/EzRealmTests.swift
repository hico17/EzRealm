import XCTest
@testable import EzRealm

final class EzRealmTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(EzRealm().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
