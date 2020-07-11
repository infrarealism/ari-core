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
    
    func testH1() {
        var page = Category.single.page
        page.content = "# hello world"
        XCTAssertEqual("<h1>hello world</h1>", page.body)
    }
    
    func testInvalidH1() {
        var page = Category.single.page
        page.content = "#hello"
        XCTAssertEqual("<p>#hello</p>", page.body)
    }
    
    func testH2() {
        var page = Category.single.page
        page.content = "## hello world"
        XCTAssertEqual("<h2>hello world</h2>", page.body)
    }
    
    func testInvalidH2() {
        var page = Category.single.page
        page.content = "##hello"
        XCTAssertEqual("<p>##hello</p>", page.body)
    }
    
    func testH3() {
        var page = Category.single.page
        page.content = "### hello world"
        XCTAssertEqual("<h3>hello world</h3>", page.body)
    }
    
    func testInvalidH3() {
        var page = Category.single.page
        page.content = "###hello"
        XCTAssertEqual("<p>###hello</p>", page.body)
    }
}

private extension Page {
    var body: String {
        render.components(separatedBy: "<section>\n")[1].components(separatedBy: "\n</section>")[0]
    }
}
