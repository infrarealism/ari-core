import Foundation

extension String {
    var parsed: String {
        components(separatedBy: "\n").map {
            $0.dropPrefix("#").flatMap {
                $0.dropPrefix("#").flatMap {
                    $0.dropPrefix("#").map {
                        $0.space(tag: "h3")
                    } ?? $0.space(tag: "h2")
                } ?? $0.space(tag: "h1")
            } ?? $0.tag("p")
        }.joined(separator: "\n")
    }
    
    private func space(tag: Self) -> Self? {
        dropPrefix(" ")?.tag(tag)
    }
    
    private func dropPrefix(_ item: Self) -> Self? {
        hasPrefix(item) ? .init(dropFirst(item.count)) : nil
    }
    
    private func tag(_ item: Self) -> Self {
        "<\(item)>\(trimmingCharacters(in: .whitespaces).content)</\(item)>"
    }
    
    private var content: String {
        isEmpty ? "&nbsp;" : marked(startIndex, result: "")
    }
    
    private func marked(_ i: Index, result: Self) -> Self {
        guard i != endIndex else { return result }
        switch self[i] {
        case "!":
            if i != index(before: endIndex), let contained = container(index(after: i)) {
                return marked(index(after: contained.i), result: result + "<img src=\"" + contained.content + "\" alt=\"" + contained.title + "\" />")
            }
        case "[":
            if let contained = container(i) {
                return marked(index(after: contained.i), result: result + "<a href=\"" + contained.content + "\">" + (contained.title.isEmpty
                    ? contained.content
                    : contained.title.marked(contained.title.startIndex, result: "")) + "</a>")
            }
        default: break
        }
        return marked(index(after: i), result: result + [self[i]])
    }
    
    private func container(_ i: Index) -> (title: String, content: String, i: Index)? {
        guard
            let title = enclosed(i, "[", "]"),
            title.i != index(before: endIndex),
            let content = enclosed(index(after: title.i), "(", ")")
        else { return nil }
        return (title.value, content.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? content.value, content.i)
    }
    
    private func enclosed(_ i: Index, _ open: Character, _ close: Character) -> (value: String, i: Index)? {
        guard self[i] == open else { return nil }
        var count = 1
        var offset = i
        while count > 0 && offset != index(before: endIndex) {
            offset = index(after: offset)
            switch self[offset] {
            case open: count += 1
            case close: count -= 1
            default: break
            }
        }
        return count == 0 ? (index(after: i) == offset ? "" : .init(self[index(after: i) ... index(before: offset)]), offset) : nil
    }
}
