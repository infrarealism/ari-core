import XCTest
@testable import Core

final class BookmarkTests: XCTestCase {
    private var url: URL!
    private var website: Website!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        website = .load(Website.single("hello", directory: url))
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
        website.close()
    }
    
    func testCreate() {
        XCTAssertEqual(url.bookmark, website.model.directory)
        XCTAssertNotNil(website.model.directory.access)
    }
    
    func testOpen() {
        XCTAssertNoThrow(try website.open())
        XCTAssertNotNil(website.url)
    }
    
    func testNoDirectory() {
        try! FileManager.default.removeItem(at: url)
        XCTAssertThrowsError(try website.open())
        XCTAssertNil(website.url)
    }
    
    func testClose() {
        try! website.open()
        website.close()
    }
}
