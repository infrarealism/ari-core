import Foundation

public extension URL {
    var bookmark: Data {
        try! bookmarkData(options: .withSecurityScope)
    }
}
