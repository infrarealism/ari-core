import XCTest
@testable import Core

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
    
    func testUpdatePage() {
        try! FileManager.default.removeItem(at: url.appendingPathComponent("hello.ari"))
        website.update(website.model.pages.first!.content("hello world"))
        XCTAssertEqual(1, website.model.pages.count)
        XCTAssertEqual("hello world", website.model.pages.first!.content)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.appendingPathComponent("hello.ari").path))
    }
    
    func testUpdateURL() {
        let other = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try! FileManager.default.createDirectory(at: other, withIntermediateDirectories: true)
        website.update(other)
        XCTAssertEqual(other.bookmark, website.model.directory)
        XCTAssertNotNil(website.model.directory.access)
        XCTAssertTrue(FileManager.default.fileExists(atPath: other.appendingPathComponent("hello.ari").path))
    }
}
