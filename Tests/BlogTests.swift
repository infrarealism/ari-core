import XCTest
import Core

final class BlogTests: XCTestCase {
    private var blog: Website.Blog!
    private var url: URL!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        blog = Website.load(Website.blog("hello", directory: url)) as? Website.Blog
        try! blog.open()
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at: url)
        blog.close()
    }
    
    func testAdd() {
        blog.add(id: "hello")
        blog.update(blog.model.pages.first { $0.id == "hello" }!.content("lorem"))
        blog.add(id: "hello")
        XCTAssertEqual(2, blog.model.pages.count)
        XCTAssertEqual("", blog.model.pages.first { $0.id == "hello" }!.content)
    }
}
