import CoreGraphics

public struct Color: Codable {
    public struct Dynamic: Codable {
        public var dark: Color
        public var light: Color
    }
    
    public static let white = Color(red: 1, green: 1, blue: 1)
    public static let black = Color(red: 0, green: 0, blue: 0)
    
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    
    public init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    var code: String {
        "#" + red.hex + green.hex + blue.hex
    }
}

private extension CGFloat {
    var hex: String {
        {
            $0.count == 1 ? "0\($0)" : $0
        } (.init(Int(self * 255), radix: 16))
    }
}
