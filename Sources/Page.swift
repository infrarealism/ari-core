import Foundation

public struct Page: Codable, Identifiable, Hashable, Renderable {
    public var id: String
    public var title = ""
    public var description = ""
    public var keywords = ""
    public var author = ""
    public internal(set) var content = ""
    
    static var today: Page {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return .init(id: formater.string(from: .init()))
    }
    
    static let index = Page(id: "index")
    
    private init(id: String) {
        self.id = id
    }
    
    public func content(_ string: String) -> Self {
        var page = self
        page.content = string
        return page
    }
    
    public func hash(into: inout Hasher) {
        into.combine(id)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    var render: String {
"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta content='width=device-width, initial-scale=1.0, shrink-to-fit=no' name='viewport'/>
    <link href="style.css" rel="stylesheet">
    <title>\(title)</title>
</head>
<body>
<section>
\(parsed)
</section>
</body>
</html>

"""
    }
    
    var file: String {
        id + ".html"
    }
    
    private var parsed: String {
        content.components(separatedBy: "\n").map {
            $0.dropPrefix("#").flatMap {
                $0.dropPrefix("#").flatMap {
                    $0.dropPrefix("#").map {
                        $0.space(tag: "h3")
                    } ?? $0.space(tag: "h2")
                } ?? $0.space(tag: "h1")
            } ?? $0.tag("p")
        }.joined(separator: "\n")
    }
}
