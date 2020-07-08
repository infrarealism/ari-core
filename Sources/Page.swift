import Foundation

public struct Page: Codable, Identifiable, Hashable {
    public var id: String
    public var date = Date()
    public var content = ""
    public let name = ""
    
    public init(id: String) {
        self.id = id
    }
    
    public func hash(into: inout Hasher) {
        into.combine(id)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
