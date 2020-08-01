import Foundation

extension Website {
    public final class Blog: Website {
        override var category: Category { .blog }
        
        public func add(id: String) {
            var pages = model.pages
            var page = Page(id: id.cleaned)
            page.title = id
            pages.remove(page)
            pages.insert(page)
            model.pages = pages
        }
        
        public func remove(_ page: Page) {
            model.pages.remove(page)
        }
        
        public func contains(id: String) -> Bool {
            model.pages.contains { $0.id == id.cleaned }
        }
        
        override func render() {
            super.render()
            let home =
"""
<p><a href="index.html">\(model.pages.first { $0 == .index }!.title.isEmpty ? "Home" : model.pages.first { $0 == .index }!.title)</a></p>
"""
            model.pages.forEach {
                render($0.render(sections: $0 == .index
                    ? [$0.content.parsed, history]
                    : [home, $0.content.parsed]),
                       file: $0.file)
            }
        }
        
        private var history: String {
"""
<ul>

""" +
            model.pages.filter { $0 != .index }.sorted { $0.created > $1.created }.reduce(into: "") {
                $0 +=
"""
<li><a href="\($1.file)">\($1.title)</a></li>

"""
            } +
"""
</ul>
"""
        }
    }
}

private extension String {
    var cleaned: Self {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "-")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}
