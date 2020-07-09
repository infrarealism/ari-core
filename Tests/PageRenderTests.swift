import XCTest
@testable import Core

final class PageRenderTests: XCTestCase {
    private var page: Page!
    private var render: String!
    
    override func setUp() {
        page = .init(id: "")
        page.title = "Hello World - Lorem Ipsum"
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
    <link href="style.css" rel="stylesheet">

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
    
    func testContent() {
        XCTAssertTrue(render.contains("""

</head>
<body>
<p>Three piggies</p>
</body>

"""))
    }
}
