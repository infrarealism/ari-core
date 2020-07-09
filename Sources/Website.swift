import Foundation

public struct Website: Codable, Identifiable {
    public var pages: Set<Page>
    public var name = ""
    public let id: UUID
    public let category: Category
    
    init(id: UUID, category: Category) {
        self.id = id
        self.category = category
        pages = [category.page]
    }
}
