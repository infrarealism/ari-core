import Foundation

public struct Style: Codable, Renderable {
    public let text = Color.Dynamic(dark: .init(red: 1, green: 1, blue: 1), light: .init(red: 0, green: 0, blue: 0))
    public let background = Color.Dynamic(dark: .init(red: 0.19607843137254902, green: 0.19607843137254902, blue: 0.19607843137254902), light: .init(red: 0.9254901960784314, green: 0.9254901960784314, blue: 0.9254901960784314))
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
        background-color: \(background.light);
        color: \(text.light);
    }
}
        
@media (prefers-color-scheme: dark) {
    body {
        background-color: \(background.dark);
        color: \(text.dark);
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
