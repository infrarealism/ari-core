import Foundation

public struct Page: Codable, Identifiable, Hashable {
    public var views = [View]()
    public let id = UUID()
    public let name = ""
    
    public init() {
        
    }
    
    public func hash(into: inout Hasher) {
        into.combine(id)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
