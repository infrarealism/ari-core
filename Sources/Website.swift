import Foundation

private let header = Data("ari.app.website".utf8)

public class Website {
    public var model: Model {
        didSet {
            save()
            render()
        }
    }
    
    public private(set) var url: URL?
    var category: Category { fatalError() }
    private var file: URL { url!.appendingPathComponent(model.name).appendingPathExtension("ari") }
    
    public class func load(_ url: URL) -> Website? {
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
    
    public class func single(_ name: String, directory: URL) -> URL {
        Single(.init(name: name, directory: directory.bookmark)).prepare()
    }
    
    public class func blog(_ name: String, directory: URL) -> URL {
        Blog(.init(name: name, directory: directory.bookmark)).prepare()
    }
    
    fileprivate init(_ model: Model) {
        self.model = model
    }
    
    public func open() throws {
        guard let url = model.directory.access else {
            throw Error.access
        }
        self.url = url
    }
    
    public func close() {
        url?.stopAccessingSecurityScopedResource()
    }
    
    public func update(_ page: Page) {
        var pages = model.pages
        pages.remove(page)
        pages.insert(page)
        model.pages = pages
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
    
    private func render() {
        model.pages.forEach {
            $0.render(url!)
        }
        model.style.render(url!)
    }
    
    enum Error: Swift.Error {
        case access
    }
}

public final class Single: Website {
    override var category: Category { .single }
}

public final class Blog: Website {
    override var category: Category { .blog }
}
