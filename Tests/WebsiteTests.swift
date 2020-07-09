import XCTest
@testable import Core

final class WebsiteTests: XCTestCase {
    private var website: Website!
    private var url: URL!
    
    override func setUp() {
        website = Category.single.make(id: .init())
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at: url)
    }
    
    func testRender() {
        website.render(url)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.appendingPathComponent("index.html").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.appendingPathComponent("style.css").path))
    }
}
