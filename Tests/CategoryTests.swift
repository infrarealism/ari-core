import XCTest
@testable import Core

final class CategoryTests: XCTestCase {
    private var website: Website!
    private var url: URL!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at: url)
        website?.close()
    }
    
    func testInvalidURL() {
        XCTAssertNil(Website.load(url))
        XCTAssertNil(Website.load(url.appendingPathComponent("some.ari")))
    }
    
    func testInvalidData() {
        let file = url.appendingPathComponent("some.ari")
        try! Data().write(to: file)
        XCTAssertNil(Website.load(file))
        
        try! Data("hello world".utf8).write(to: file)
        XCTAssertNil(Website.load(file))
        
        Data("ari.website".utf8).compress(to: file)
        XCTAssertNil(Website.load(file))
        
        (Data("ari.website".utf8) + [Category.blog.rawValue]).compress(to: file)
        XCTAssertNil(Website.load(file))
        
        try! (Data("ari.website".utf8) + Data([Category.blog.rawValue]) + JSONEncoder().encode("hello")).compress(to: file)
        XCTAssertNil(Website.load(file))
        
        try! (Data("ari.website".utf8) + Data([UInt8(9)]) + JSONEncoder().encode(Model(name: "adfdasdas", directory: .init()))).compress(to: file)
        XCTAssertNil(Website.load(file))
        
        try! (Data("ara.website".utf8) + Data([Category.single.rawValue]) + JSONEncoder().encode(Model(name: "adfdasdas", directory: .init()))).compress(to: file)
        XCTAssertNil(Website.load(file))
    }
    
    func testSingle() {
        _ = Website.single("aloha", directory: url)
        
        let loaded = Website.load(url.appendingPathComponent("aloha.ari"))
        XCTAssertTrue(loaded is Website.Single)
        XCTAssertEqual("aloha", loaded?.model.name)
    }
}
