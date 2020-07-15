import Foundation

public struct Page: Codable, Identifiable, Hashable, Renderable {
    public var id: String
    public var title = ""
    public var description = ""
    public var keywords = ""
    public var author = ""
    public var content = ""
    
    public init(id: String) {
        self.id = id
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

private extension String {
    func space(tag: String) -> String? {
        dropPrefix(" ")?.tag(tag)
    }
    
    func dropPrefix(_ item: String) -> String? {
        hasPrefix(item) ? .init(dropFirst(item.count)) : nil
    }
    
    func tag(_ item: String) -> String {
        "<\(item)>\(content)</\(item)>"
    }
    
    private var content: String {
        {
            $0.isEmpty ? "&nbsp;"
                : $0.parsed
        } (trimmingCharacters(in: .whitespaces))
    }
    
    private var parsed: String {
        {
            $0.count < 2 ? self : $0.reduce(into: "") {
                $0 += $1.link ?? $1 + ($1.isEmpty ? "" : ")")
            }
        } (components(separatedBy: ")"))
    }
    
    private var link: String? {
        {
            $0.count == 2 ? {
                $0.count == 2 ? $0.last! : nil
            } ($0.first!.components(separatedBy: "("))?.reduce(into: "<a href=\"\($0.last!)\">") {
                $0 += $1 + "</a>"
            } : nil
        } (components(separatedBy: "]("))
    }
}
