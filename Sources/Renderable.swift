import Foundation

public protocol Renderable {
    var render: String { get }
    var file: String { get }
}
