import Foundation

public enum Category: String, Codable {
    case
    single,
    blog
    
    public func make(id: UUID) -> Website {
        .init(id: id, category: self)
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
