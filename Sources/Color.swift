import CoreGraphics

public struct Color: Codable, Equatable {
    public struct Dynamic: Codable {
        public var dark: Color
        public var light: Color
    }
    
    public static let white = Color(red: 1, green: 1, blue: 1)
    public static let black = Color(red: 0, green: 0, blue: 0)
    public static let blue = Color(red: 0.0392156862745098, green: 0.5176470588235295, blue: 1.0)
    public static let indigo = Color(red: 0.3686274509803922, green: 0.3607843137254902, blue: 0.9019607843137255)
    public static let purple = Color(red: 0.7490196078431373, green: 0.35294117647058826, blue: 0.9490196078431372)
    public static let pink = Color(red: 1.0, green: 0.21568627450980393, blue: 0.37254901960784315)
    public static let orange = Color(red: 1.0, green: 0.6235294117647059, blue: 0.0392156862745098)
    
    public let red: CGFloat
    public let green: CGFloat
    public let blue: CGFloat
    
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
