import Foundation

extension Website {
    public final class Single: Website {
        override var category: Category { .single }
        
        override func render() {
            super.render()
            model.pages.first!.render(url!)
        }
    }
}
