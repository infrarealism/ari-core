import XCTest
@testable import Core

final class PageContentTests: XCTestCase {
    func testWhiteSpace() {
        var page = Page.index
        page.content = "hello world  "
        XCTAssertEqual("<p>hello world</p>", page.content.parsed)
    }
    
    func testLineBreaks() {
        var page = Page.index
        page.content = "hello\nworld"
        XCTAssertEqual("<p>hello</p>\n<p>world</p>", page.content.parsed)
    }
    
    func testLineBreakWhiteSpace() {
        var page = Page.index
        page.content = "hello\nworld  \n"
        XCTAssertEqual("<p>hello</p>\n<p>world</p>\n<p>&nbsp;</p>", page.content.parsed)
    }
    
    func testMultipleLineBreaks() {
        var page = Page.index
        page.content = "hello\n\nworld"
        XCTAssertEqual("<p>hello</p>\n<p>&nbsp;</p>\n<p>world</p>", page.content.parsed)
    }
    
    func testEmptyLineBreaksSpaces() {
        var page = Page.index
        page.content = "  \n     \nhello"
        XCTAssertEqual("<p>&nbsp;</p>\n<p>&nbsp;</p>\n<p>hello</p>", page.content.parsed)
    }
    
    func testH1() {
        var page = Page.index
        page.content = "# hello world"
        XCTAssertEqual("<h1>hello world</h1>", page.content.parsed)
    }
    
    func testInvalidH1() {
        var page = Page.index
        page.content = "#hello"
        XCTAssertEqual("<p>#hello</p>", page.content.parsed)
    }
    
    func testH2() {
        var page = Page.index
        page.content = "## hello world"
        XCTAssertEqual("<h2>hello world</h2>", page.content.parsed)
    }
    
    func testInvalidH2() {
        var page = Page.index
        page.content = "##hello"
        XCTAssertEqual("<p>##hello</p>", page.content.parsed)
    }
    
    func testH3() {
        var page = Page.index
        page.content = "### hello world"
        XCTAssertEqual("<h3>hello world</h3>", page.content.parsed)
    }
    
    func testInvalidH3() {
        var page = Page.index
        page.content = "###hello"
        XCTAssertEqual("<p>###hello</p>", page.content.parsed)
    }
    
    func testNotItem() {
        var page = Page.index
        page.content = "["
        XCTAssertEqual("<p>" + page.content + "</p>", page.content.parsed)
        page.content = "]"
        XCTAssertEqual("<p>" + page.content + "</p>", page.content.parsed)
        page.content = "[]"
        XCTAssertEqual("<p>" + page.content + "</p>", page.content.parsed)
        page.content = "[ ]"
        XCTAssertEqual("<p>" + page.content + "</p>", page.content.parsed)
        page.content = "[]("
        XCTAssertEqual("<p>" + page.content + "</p>", page.content.parsed)
        page.content = "[](hdasd"
        XCTAssertEqual("<p>" + page.content + "</p>", page.content.parsed)
        page.content = "[](hdasd ()"
        XCTAssertEqual("<p>" + page.content + "</p>", page.content.parsed)
        page.content = "!"
        XCTAssertEqual("<p>" + page.content + "</p>", page.content.parsed)
        page.content = "!["
        XCTAssertEqual("<p>" + page.content + "</p>", page.content.parsed)
        page.content = "!]"
        XCTAssertEqual("<p>" + page.content + "</p>", page.content.parsed)
        page.content = "[!()]("
        XCTAssertEqual("<p>" + page.content + "</p>", page.content.parsed)
    }
    
    func testNotLink() {
        var page = Page.index
        page.content = "hello ](lorem ipsum)"
        XCTAssertEqual("<p>hello ](lorem ipsum)</p>", page.content.parsed)
    }
    
    func testLink() {
        var page = Page.index
        page.content = "[hello](lorem)"
        XCTAssertEqual("<p><a href=\"lorem\">hello</a></p>", page.content.parsed)
    }
    
    func testEmptyLink() {
        var page = Page.index
        page.content = "[](https://www.google.com/q=hello world)"
        XCTAssertEqual("<p><a href=\"https://www.google.com/q=hello%20world\">https://www.google.com/q=hello%20world</a></p>", page.content.parsed)
    }
    
    func testLinkEscaped() {
        var page = Page.index
        page.content = "[hello](lorem ipsum)"
        XCTAssertEqual("<p><a href=\"lorem%20ipsum\">hello</a></p>", page.content.parsed)
    }
    
    func testLinkURL() {
        var page = Page.index
        page.content = "[hello](https://www.google.com)"
        XCTAssertEqual("<p><a href=\"https://www.google.com\">hello</a></p>", page.content.parsed)
    }
    
    func testImage() {
        var page = Page.index
        page.content = "![hello world](some/lorem ipsum.png)"
        XCTAssertEqual("<p><img src=\"some/lorem%20ipsum.png\" alt=\"hello world\" /></p>", page.content.parsed)
    }
    
    func testImageLink() {
        var page = Page.index
        page.content = "[![hello world](some/lorem ipsum.png)](https://google.com)"
        XCTAssertEqual("<p><a href=\"https://google.com\"><img src=\"some/lorem%20ipsum.png\" alt=\"hello world\" /></a></p>", page.content.parsed)
    }
}
