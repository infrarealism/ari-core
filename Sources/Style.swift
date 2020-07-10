import Foundation

public struct Style: Codable, Renderable {
    public var link = Color
    public let text = Color
    public let background = Color(red: 0.11764705882352941, green: 0.11764705882352941, blue: 0.11764705882352941)
    let file: String = "style.css"
    
    var render: String {
        """
*, :after, :before {
    box-sizing:border-box
}

html {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
    line-height: 1.15;
    -webkit-text-size-adjust: 100%;
    -webkit-tap-highlight-color:transparent
}
        
@media (prefers-color-scheme: light) {
    body {
        background-color: white;
        color: black;
    }
}
        
@media (prefers-color-scheme: dark) {
    body {
        background-color: black;
        color: white;
    }
}

body {
    margin: 0;
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    text-align: left;
}

"""
    }
}
