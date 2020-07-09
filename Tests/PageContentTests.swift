import XCTest
@testable import Core

final class PageContentTests: XCTestCase {
    func testWhiteSpace() {
        var page = Category.single.page
        page.content = "hello world  "
        XCTAssertEqual("<p>hello world</p>", page.body)
    }
    
    func testLineBreaks() {
        var page = Category.single.page
        page.content = "hello\nworld"
        XCTAssertEqual("<p>hello</p>\n<p>world</p>", page.body)
    }
    
    func testLineBreakWhiteSpace() {
        var page = Category.single.page
        page.content = "hello\nworld  \n"
        XCTAssertEqual("<p>hello</p>\n<p>world</p>", page.body)
    }
    
    func testMultipleLineBreaks() {
        var page = Category.single.page
        page.content = "hello\n\nworld"
        XCTAssertEqual("<p>hello</p>\n<p></p>\n<p>world</p>", page.body)
    }
}

private extension Page {
    var body: String {
        render.components(separatedBy: "<body>\n")[1].components(separatedBy: "\n</body>")[0]
    }
}
