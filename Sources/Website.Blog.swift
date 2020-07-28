import Foundation

extension Website {
    public final class Blog: Website {
        override var category: Category { .blog }
        
        public func add(id: String) {
            let page = Page(id: id)
            model.pages.remove(page)
            model.pages.insert(page)
        }
    }
}
