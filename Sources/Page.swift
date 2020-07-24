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
            $0.isEmpty ? "&nbsp;" : $0.marked()
        } (trimmingCharacters(in: .whitespaces))
    }
    
    private func marked(_ i: Index? = nil, result: Self = "") -> Self {
        i == endIndex ? result : { i in
            switch self[i] {
//            case "!":
//                return ""
            case "[":
                if let container = Self(self[i ..< endIndex]).container {
                    return container.ending == index(before: endIndex) ? result + container.title + container.content : ""
                }
            default: break
            }
            
            return marked(index(after: i), result: result + [self[i]])
        } (i ?? startIndex)
    }
    
    
    private var container: (title: String, content: String, ending: Index)? {
        guard
            let title = enclosed("[", "]"),
            title.ending != endIndex && title.ending != index(before: endIndex),
            let content = Self(self[index(after: title.ending) ..< endIndex]).enclosed("(", ")")
        else { return nil }
        return (title.content, content.content, content.ending)
    }
    
    private func enclosed(_ open: Character, _ close: Character) -> (content: String, ending: Index)? {
        guard self[startIndex] == open else { return nil }
        var count = 1
        var i = startIndex
        while count > 0 && i != endIndex {
            i = index(after: i)
            switch self[i] {
            case open: count += 1
            case close: count -= 1
            default: break
            }
        }
        return count == 0 ? (.init(self[index(after: startIndex) ... index(before: i) ]), i) : nil
    }
    
    
    
    
    
    
    
    
    private var parsed: String {
        {
            $0.count < 2 ? self : $0.reduce(into: "") {
                $0 += $1.item ?? $1 + ($1.isEmpty ? "" : ")")
            }
        } (components(separatedBy: ")"))
    }
    
    private var item: String? {
        {
            if let url = { $0.count == 2 ? $0.last?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) : nil } ($0) {
                if let image = $0.first!.image {
                    return "<img src=\"\(url)\" alt=\"\(image)\" />"
                }
                if let link = $0.first!.link {
                    return "<a href=\"\(url)\">" + link + "</a>"
                }
            }
            return nil
        } (components(separatedBy: "]("))
    }
    
    private var image: String? {
        {
            $0.count == 2 ? $0.last! : nil
        } (components(separatedBy: "!["))
    }
    
    private var link: String? {
        {
            $0.count == 2 ? $0.last! : nil
        } (components(separatedBy: "["))
    }
}
