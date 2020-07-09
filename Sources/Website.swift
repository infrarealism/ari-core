import Foundation

public struct Website: Codable, Identifiable {
    public var name = ""
    public var pages: Set<Page>
    public var style = Style()
    public let id: UUID
    public let category: Category
    
    init(id: UUID, category: Category) {
        self.id = id
        self.category = category
        pages = [category.page]
    }
    
    public func render(_ url: URL) {
        pages.forEach {
            $0.render(url)
        }
        style.render(url)
    }
}
