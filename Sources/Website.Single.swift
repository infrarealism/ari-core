import Foundation

extension Website {
    public final class Single: Website {
        override var category: Category { .single }
        
        override func render() {
            super.render()
            render(model.pages.first!.render(sections: [model.pages.first!.content.parsed]), file: model.pages.first!.file)
        }
    }
}
