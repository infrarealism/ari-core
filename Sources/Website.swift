import Foundation

private let header = Data("ari.website".utf8)

public class Website {
    public var model: Model {
        didSet {
            save()
            render()
        }
    }
    
    public var file: URL { url!.appendingPathComponent(model.name).appendingPathExtension("ari") }
    public private(set) var url: URL?
    var category: Category { fatalError() }
    
    public final class func load(_ url: URL) -> Website? {
        guard
            let data = try? Data(contentsOf: url).decompressed,
            data.prefix(header.count) == header,
            data.count > header.count,
            let category = Category(rawValue: data[header.count]),
            let model = try? JSONDecoder().decode(Model.self, from: data.dropFirst(header.count + 1))
        else { return nil }
        
        switch category {
        case .single: return Single(model)
        case .blog: return Blog(model)
        }
    }
    
    public final class func single(_ name: String, directory: URL) -> URL {
        Single(.init(name: name, directory: directory.bookmark)).prepare()
    }
    
    public final class func blog(_ name: String, directory: URL) -> URL {
        Blog(.init(name: name, directory: directory.bookmark)).prepare()
    }
    
    init(_ model: Model) {
        self.model = model
    }
    
    public final func open() throws {
        guard let url = model.directory.access else {
            throw Error.access
        }
        self.url = url
    }
    
    public final func close() {
        url?.stopAccessingSecurityScopedResource()
    }
    
    public final func update(_ page: Page) {
        var pages = model.pages
        pages.remove(page)
        pages.insert(page)
        model.pages = pages
    }
    
    public final func update(_ url: URL) {
        let bookmark = url.bookmark
        self.url = bookmark.access
        model.directory = bookmark
    }
    
    func render() {
        render(model.style.render, file: "style.css")
    }
    
    final func render(_ content: String, file: String) {
        try! Data(content.utf8).write(to: url!.appendingPathComponent(file))
    }
    
    final func rasterize(_ page: Page, sections: [String]) -> String {
"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta content='width=device-width, initial-scale=1.0, shrink-to-fit=no' name='viewport'/>
    <meta name="description" content="\(page.description)">
    <meta name="keywords" content="\(page.keywords)">
    <meta name="author" content="\(page.author)">
    <title>\(page.title)</title>
    <link href="style.css" rel="stylesheet">
</head>
<body>
\(sections.reduce(into: "") {
    $0 +=
"""
<section>
\($1)
</section>
        
"""
})
</body>
</html>

"""
    }
    
    private func prepare() -> URL {
        try! open()
        save()
        close()
        return file
    }
    
    private func save() {
        try! (header + [category.rawValue] + JSONEncoder().encode(model)).compress(to: file)
    }
}
