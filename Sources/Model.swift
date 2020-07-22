import Foundation

public struct Model: Codable {
    public var pages = Set<Page>([.index])
    public var style = Style()
    public var name: String
    let directory: Data
}
