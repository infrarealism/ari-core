import Foundation

public struct Page: Codable, Identifiable, Hashable {
    public var id: String
    public var title = ""
    public var description = ""
    public var keywords = ""
    public var author = ""
    public var content = ""
    public var date = Date()
    
    public init(id: String) {
        self.id = id
    }
    
    public func hash(into: inout Hasher) {
        into.combine(id)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    public var render: String {
"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta content='width=device-width, initial-scale=1.0, shrink-to-fit=no' name='viewport'/>
    <title>\(title)</title>
</head>
<body>
    \(content)
</body>
</html>

"""
    }
}
