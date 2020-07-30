import Foundation

extension Website {
    public final class Blog: Website {
        override var category: Category { .blog }
        
        public func add(id: String) {
            let page = Page(id: id
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: " ", with: "-"))
            model.pages.remove(page)
            model.pages.insert(page)
        }
        
        public func remove(_ page: Page) {
            model.pages.remove(page)
        }
    }
}