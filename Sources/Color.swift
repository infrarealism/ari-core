import CoreGraphics

public struct Color: Codable {
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
