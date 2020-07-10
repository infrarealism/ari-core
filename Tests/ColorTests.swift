import XCTest
@testable import Core

final class ColorTests: XCTestCase {
    func testRed() {
        XCTAssertEqual("#ff0000", Color(red: 1, green: 0, blue: 0).code)
    }
    
    func testTwoCharacters() {
        XCTAssertEqual("#0c0000", Color(red: 0.05, green: 0, blue: 0).code)
    }
}
