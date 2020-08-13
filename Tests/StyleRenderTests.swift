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
        -webkit-tap-highlight-color:transparent;
}

"""))
    }
    
    func testColors() {
        style.colors.forEach {
            XCTAssertTrue($0.hasPrefix("#"))
            XCTAssertTrue($0.hasSuffix(";"))
            XCTAssertEqual(8, $0.count)
        }
    }
}

private extension Style {
    var colors: [String] {
        render.components(separatedBy: "\n").compactMap {
            let a = $0.components(separatedBy: "color: ")
            return a.count > 1 ? a[1] : nil
        }
    }
}
