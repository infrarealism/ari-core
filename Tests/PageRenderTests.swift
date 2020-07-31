import XCTest
@testable import Core

final class PageRenderTests: XCTestCase {
    private var page: Page!
    private var render: String!
    
    override func setUp() {
        page = .index
        page.title = "Hello World - Lorem Ipsum"
        page.description = "lorem ipsum"
        page.keywords = "a, b, c"
        page.author = "Piggy @piggy"
        page.content = "Three piggies"
        render = page.render
    }
    
    func testWrappers() {
        XCTAssertTrue(render.hasPrefix("""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta content='width=device-width, initial-scale=1.0, shrink-to-fit=no' name='viewport'/>

"""))
        XCTAssertTrue(render.contains("""

</head>
<body>

"""))
        XCTAssertTrue(render.hasSuffix("""

</body>
</html>

"""))
    }
    
    func testTitle() {
        XCTAssertTrue(render.contains("""

    <title>Hello World - Lorem Ipsum</title>

"""))
    }
    
    func testDescription() {
            XCTAssertTrue(render.contains("""

    <meta name="description" content="lorem ipsum">

"""))
    }
    
    func testKeywords() {
                XCTAssertTrue(render.contains("""

    <meta name="keywords" content="a, b, c">

"""))
    }
    
    func testAuthor() {
                XCTAssertTrue(render.contains("""

    <meta name="author" content="Piggy @piggy">

"""))
    }
    
    func testContent() {
        XCTAssertTrue(render.contains("""

</head>
<body>
<section>
<p>Three piggies</p>
</section>
</body>

"""))
    }
}
