import XCTest
@testable import RealmManager

final class RealmManagerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RealmManager().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
