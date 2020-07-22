import Foundation

public struct Website: Codable {
    public var name: String
    public var pages: Set<Page>
    public var style = Style()
    public let category: Category
    
    init(_ name: String, category: Category) {
        self.name = name
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
