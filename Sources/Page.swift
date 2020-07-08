import Foundation

public struct Page: Codable, Identifiable, Hashable {
    public let id = UUID()
    public var date = Date()
    public let name = ""
    public var content = ""
    
    public init() {
        
    }
    
    public func hash(into: inout Hasher) {
        into.combine(id)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
