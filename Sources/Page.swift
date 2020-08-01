import Foundation

public struct Page: Codable, Identifiable, Hashable {
    public static let index = Page(id: "index")
    public var id: String
    public var title = ""
    public var description = ""
    public var keywords = ""
    public var author = ""
    public internal(set) var content = ""
    public let created: Date
    
    init(id: String) {
        self.id = id
        created = .init()
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
    
    public var file: String {
        id + ".html"
    }
    
    func render(sections: [String]) -> String {
"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta content='width=device-width, initial-scale=1.0, shrink-to-fit=no' name='viewport'/>
    <meta name="description" content="\(description)">
    <meta name="keywords" content="\(keywords)">
    <meta name="author" content="\(author)">
    <title>\(title)</title>
    <link href="style.css" rel="stylesheet">
</head>
<body>
\(sections.reduce(into: "") {
    $0 +=
"""
<section>
\($1)
</section>
"""
})
</body>
</html>

"""
        }
}
