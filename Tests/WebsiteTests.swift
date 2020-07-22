import XCTest
@testable import Core

final class WebsiteTests: XCTestCase {
    private var website: Website!
    private var url: URL!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        website = .single("hello", directory: url)
        try! website.open()
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at: url)
        website.close()
    }
    
    func testRender() {
        website.render()
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.appendingPathComponent("index.html").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.appendingPathComponent("style.css").path))
    }
    
    func testSave() {
        website.save()
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.appendingPathComponent("hello.ari").path))
    }
}
