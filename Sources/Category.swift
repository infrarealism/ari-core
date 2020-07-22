import Foundation

public enum Category: String, Codable {
    case
    single,
    blog
    
    public func make(_ name: String) -> Website {
        .init(name, category: self)
    }
    
    var page: Page {
        switch self {
        case .single:
            return .init(id: "index")
        case .blog:
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            return .init(id: formater.string(from: .init()))
        }
    }
}
