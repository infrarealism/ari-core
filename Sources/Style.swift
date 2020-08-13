import Foundation

public struct Style: Codable {
    public var primary = Color.blue
    public var secondary = Color.pink
    public let text = Color.Dynamic(dark: .init(red: 1, green: 1, blue: 1), light: .init(red: 0, green: 0, blue: 0))
    public let background = Color.Dynamic(dark: .init(red: 0.196, green: 0.196, blue: 0.196), light: .init(red: 0.9254, green: 0.9254, blue: 0.9254))
    
    var render: String {
        """
*, :after, :before {
        box-sizing:border-box
}

html {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
        line-height: 1.15;
        -webkit-text-size-adjust: 100%;
        -webkit-tap-highlight-color:transparent;
}
        
@media (prefers-color-scheme: light) {
        body {
            background-color: \(background.light.code);
            color: \(text.light.code);
        }
}
        
@media (prefers-color-scheme: dark) {
        body {
            background-color: \(background.dark.code);
            color: \(text.dark.code);
        }
}

body {
        margin: 0;
        padding: 20px;
        font-size: 1rem;
        font-weight: 400;
        line-height: 1.4;
        text-align: left;
}

h1, h2, h3 {
        color: \(primary.code);
        font-weight: 700;
        line-height: 1;
        margin: 0;
}

h1 {
        font-size: 3rem;
}

h2 {
        font-size: 2rem;
}

a {
        color: \(secondary.code);
        text-decoration: none;
}

a:hover {
        color: \(secondary.code);
}
        
p {
        margin: 0;
}
        
section {
        width: 960px;
        margin: 0 auto;
}
        
@media print, screen and (max-width: 960px) {
        body {
            word-wrap: break-word;
        }
        
        section {
            width: auto;
            margin: 0;
        }
}
        
@media print {
        body {
            padding: 0.4in;
            font-size: 12pt;
        }
}

"""
    }
}
