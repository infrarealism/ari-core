import XCTest
@testable import Core

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
    
    func testRender() {
        blog.add(id: "first")
        blog.add(id: "second")
        
        var first = blog.model.pages.first { $0.id == "first" }!
        first.title = "First page"
        blog.update(first)
        
        var second = blog.model.pages.first { $0.id == "second" }!
        second.title = "Second page"
        blog.update(second)
        
        blog.update(blog.model.pages.first { $0 == .index }!.content("welcome"))
        blog.update(blog.model.pages.first { $0.id == "first" }!.content("hello world"))
        blog.update(blog.model.pages.first { $0.id == "second" }!.content("lorem ipsum"))

        XCTAssertTrue(blog.model.pages.first { $0 == .index }!.render.contains("""

<p>welcome</p>

"""))
        
        XCTAssertTrue(blog.model.pages.first { $0 == .index }!.render.contains("""

<ul>
<li><a href="second.html">Second page</a></li>
<li><a href="first.html">First page</a></li>
</ul>

"""))
    }
}
