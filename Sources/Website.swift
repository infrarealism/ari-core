import Foundation

public struct Website: Codable, Identifiable {
    public var pages = Set<Page>()
    public var name = ""
    public let id = UUID()
    public let category: Category
    
    public init(category: Category) {
        self.category = category
    }
}
