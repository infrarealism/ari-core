import Foundation

public enum Category: String, Codable {
    case
    single,
    blog
    
    func make(id: UUID) -> Website {
        .init(id: id, category: self)
    }
}
