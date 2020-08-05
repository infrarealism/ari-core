import Foundation

public extension URL {
#if os(macOS)
    var bookmark: Data {
        try! bookmarkData(options: .withSecurityScope)
    }
#endif
#if os(iOS)
    var bookmark: Data {
        try! bookmarkData()
    }
#endif
    
    var directory: String? {
        getpwuid(getuid()).pointee.pw_dir.map {
            FileManager.default.string(withFileSystemRepresentation: $0, length: .init(strlen($0)))
        }.map {
            NSString(string: path.replacingOccurrences(of: $0, with: "~")).abbreviatingWithTildeInPath
        }
    }
}
