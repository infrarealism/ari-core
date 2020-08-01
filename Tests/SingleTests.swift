import XCTest
@testable import Core

final class SingleTests: XCTestCase {
    private var single: Website.Single!
    private var url: URL!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        single = Website.load(Website.single("hello", directory: url)) as? Website.Single
        try! single.open()
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at: url)
        single.close()
    }
    
    func testRender() {
        single.update(single.model.pages.first!.content("Three piggies"))
        let index = try! String(decoding: Data(contentsOf: url.appendingPathComponent("index.html")), as: UTF8.self)
        XCTAssertTrue(index.contains("""

</head>
<body>
<section>
<p>Three piggies</p>
</section>
</body>

"""))
    }
}
