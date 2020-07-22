import Foundation

private let header = Data("ari.app.website".utf8)

public class Website {
    public var model: Model
    var category: Category { fatalError() }
    private(set) var url: URL?
    
    class func load(_ url: URL) -> Website? {
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
    
    class func single(_ name: String, directory: URL) -> Single {
        .init(name, directory: directory)
    }
    
    class func blog(_ name: String, directory: URL) -> Blog {
        .init(name, directory: directory)
    }
    
    fileprivate init(_ model: Model) {
        self.model = model
    }
    
    fileprivate init(_ name: String, directory: URL) {
        model = .init(name: name, directory: directory.bookmark)
    }
    
    public func open() throws {
        guard let url = model.directory.access else {
            throw Error.access
        }
        self.url = url
    }
    
    func close() {
        url?.stopAccessingSecurityScopedResource()
        url = nil
    }
    
    public func render() {
        model.pages.forEach {
            $0.render(url!)
        }
        model.style.render(url!)
    }
    
    public func save() {
        try! (header + [category.rawValue] + JSONEncoder().encode(model)).compress(to: url!.appendingPathComponent(model.name).appendingPathExtension("ari"))
    }
    
    public var directory: String? {
        url.map(\.path).flatMap { path in
            getpwuid(getuid()).pointee.pw_dir.map {
                FileManager.default.string(withFileSystemRepresentation: $0, length: .init(strlen($0)))
            }.map {
                NSString(string: path.replacingOccurrences(of: $0, with: "~")).abbreviatingWithTildeInPath
            }
        }
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
