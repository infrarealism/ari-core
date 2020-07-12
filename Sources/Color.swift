import Foundation

public struct Color: Codable, Equatable {
    public struct Dynamic: Codable {
        public var dark: Color
        public var light: Color
    }
    
    public static let white = Color(red: 1, green: 1, blue: 1)
    public static let black = Color(red: 0, green: 0, blue: 0)
    public static let blue = Color(red: 0.0392, green: 0.5176, blue: 1)
    public static let indigo = Color(red: 0.3686, green: 0.3607, blue: 0.9019)
    public static let purple = Color(red: 0.749, green: 0.3529, blue: 0.949)
    public static let pink = Color(red: 1, green: 0.2156, blue: 0.3725)
    public static let orange = Color(red: 1, green: 0.6235, blue: 0.0392)
    
    public let red: Double
    public let green: Double
    public let blue: Double
    
    public init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    var code: String {
        "#" + red.hex + green.hex + blue.hex
    }
}

private extension Double {
    var hex: String {
        {
            $0.count == 1 ? "0\($0)" : $0
        } (.init(Int(self * 255), radix: 16))
    }
}
