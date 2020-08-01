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
        blog.add(id: "hello\\world")
        XCTAssertEqual("hello%5Cworld", blog.model.pages.sorted { $0.created > $1.created }.first!.id)
    }
    
    func testTitle() {
        blog.add(id: "hello world")
        XCTAssertEqual("hello world", blog.model.pages.sorted { $0.created > $1.created }.first!.title)
    }
    
    func testContains() {
        blog.add(id: "hello world")
        XCTAssertTrue(blog.contains(id: "hello world"))
        XCTAssertTrue(blog.contains(id: "hello-world"))
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
        
        var _index = blog.model.pages.first { $0 == .index }!
        _index.title = "Start here"
        blog.update(_index)
        
        var _first = blog.model.pages.first { $0.id == "first" }!
        _first.title = "First page"
        blog.update(_first)
        
        var _second = blog.model.pages.first { $0.id == "second" }!
        _second.title = "Second page"
        blog.update(_second)
        
        blog.update(blog.model.pages.first { $0 == .index }!.content("welcome"))
        blog.update(blog.model.pages.first { $0.id == "first" }!.content("hello world"))
        blog.update(blog.model.pages.first { $0.id == "second" }!.content("lorem ipsum"))

        let index = try! String(decoding: Data(contentsOf: url.appendingPathComponent("index.html")), as: UTF8.self)
        XCTAssertTrue(index.contains("""

<p>welcome</p>

"""))
        XCTAssertTrue(index.contains("""

<ul>
<li><a href="second.html">Second page</a></li>
<li><a href="first.html">First page</a></li>
</ul>

"""))
        
        let item = try! String(decoding: Data(contentsOf: url.appendingPathComponent("first.html")), as: UTF8.self)
        XCTAssertTrue(item.contains("""

<p>hello world</p>

"""))
        XCTAssertTrue(item.contains("""

<p><a href="index.html">Start here</a></p>

"""))
    }
    
    func testNoTitleForIndex() {
        blog.add(id: "first")
        let item = try! String(decoding: Data(contentsOf: url.appendingPathComponent("first.html")), as: UTF8.self)
        XCTAssertTrue(item.contains("""

<p><a href="index.html">Home</a></p>

"""))
    }
}
