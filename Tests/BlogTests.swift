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
    
    func testName() {
        blog.add(id: "hello ")
        XCTAssertEqual("hello", blog.model.pages.sorted { $0.created > $1.created }.first!.id)
        blog.add(id: "hello\n")
        XCTAssertEqual("hello", blog.model.pages.sorted { $0.created > $1.created }.first!.id)
        blog.add(id: "hello world")
        XCTAssertEqual("hello-world", blog.model.pages.sorted { $0.created > $1.created }.first!.id)
    }
    
    func testRemove() {
        blog.add(id: "hello")
        blog.remove(blog.model.pages.filter { $0 != .index }.first!)
        XCTAssertEqual(1, blog.model.pages.count)
        XCTAssertTrue(blog.model.pages.contains(.index))
    }
}
