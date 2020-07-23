import XCTest
import Core

final class WebsiteTests: XCTestCase {
    private var website: Website!
    private var url: URL!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        website = .load(Website.single("hello", directory: url))
        try! website.open()
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at: url)
        website.close()
    }
    
    func testSaveAndRender() {
        try! FileManager.default.removeItem(at: url.appendingPathComponent("hello.ari"))
        website.model.style.primary = .blue
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.appendingPathComponent("hello.ari").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.appendingPathComponent("index.html").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.appendingPathComponent("style.css").path))
    }
    
    func testFactory() {
        let new = Website.single("ultravox", directory: url)
        XCTAssertTrue(new.lastPathComponent.contains("ultravox"))
        XCTAssertEqual("ari", new.pathExtension)
        XCTAssertTrue(FileManager.default.fileExists(atPath: new.path))
    }
}
