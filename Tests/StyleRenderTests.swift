import XCTest
@testable import Core

final class StyleRenderTests: XCTestCase {
    private var style: Style!
    private var render: String!
    
    override func setUp() {
        style = .init()
        render = style.render
    }
    
    func testPrefix() {
        XCTAssertTrue(render.hasPrefix("""
*, :after, :before {
    box-sizing:border-box
}

html {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
    line-height: 1.15;
    -webkit-text-size-adjust: 100%;
    -webkit-tap-highlight-color:transparent
}

"""))
    }
}
