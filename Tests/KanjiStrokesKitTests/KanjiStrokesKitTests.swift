import XCTest
@testable import KanjiStrokesKit

final class KanjiStrokesKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(KanjiStrokesKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
