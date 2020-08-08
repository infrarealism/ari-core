import Foundation

public extension Data {
#if os(macOS)
    var access: URL? {
        var stale = false
        return (try? URL(resolvingBookmarkData: self, options: .withSecurityScope, bookmarkDataIsStale: &stale)).flatMap {
            $0.startAccessingSecurityScopedResource() ? $0 : nil
        }
    }
#endif
#if os(iOS)
    var access: URL? {
        var stale = false
        return (try? URL(resolvingBookmarkData: self, bookmarkDataIsStale: &stale)).flatMap {
            $0.startAccessingSecurityScopedResource() ? $0 : nil
        }
    }
#endif
}

extension Data {
    var decompressed: Data? {
        try? (self as NSData).decompressed(using: .lzfse) as Data
    }
    
    func compress(to url: URL) {
        try? (self as NSData).compressed(using: .lzfse).write(to: url, options: .atomic)
    }
}
