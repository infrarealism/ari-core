import Foundation

protocol Renderable {
    var render: String { get }
    var file: String { get }
}

extension Renderable {
    func render(_ url: URL) {
        try? Data(render.utf8).write(to: url.appendingPathComponent(file))
    }
}
