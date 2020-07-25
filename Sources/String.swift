import Foundation

extension String {
    func space(tag: Self) -> Self? {
        dropPrefix(" ")?.tag(tag)
    }
    
    func dropPrefix(_ item: Self) -> Self? {
        hasPrefix(item) ? .init(dropFirst(item.count)) : nil
    }
    
    func tag(_ item: Self) -> Self {
        "<\(item)>\(trimmingCharacters(in: .whitespaces).content)</\(item)>"
    }
    
    private var content: String {
        isEmpty ? "&nbsp;" : marked(startIndex, result: "")
    }
    
    private func marked(_ i: Index, result: Self) -> Self {
        guard i != endIndex else { return result }
        var i = i
                    var result = result
                    switch self[i] {
                    case "!":
                        container(index(after: i)).map {
                            i = $0.i
                            result += "<img src=" + $0.content + " alt=" + $0.title + " />"
                        }
                    case "[":
                        container(i).map {
                            i = $0.i
                            result += "<a href=" + $0.content + ">" + $0.title + "</a>"
                        }
                    default:
                        result.append(self[i])
                    }
                    return marked(index(after: i), result: result)
    }
    
    private func container(_ i: Index) -> (title: String, content: String, i: Index)? {
        guard
            let title = enclosed(i, "[", "]"),
            title.i != endIndex && title.i != index(before: endIndex),
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
        return count == 0 ? (.init(self[index(after: i) ... index(before: offset)]), offset) : nil
    }
    
    
}
