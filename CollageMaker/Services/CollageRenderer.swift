//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class CollageRenderer {
    
    static func renderImage(from collage: Collage, with size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            collage.allCells().forEach { render(cell: $0, in: context) }
        }
    }
    
    private static func render(cell: CollageCell, in context: UIGraphicsRendererContext) {
        let rect = cell.relativePosition.absolutePosition(in: context.format.bounds)
        
        if let image = cell.image {
            image.draw(in: rect)
        } else {
            cell.color.setFill()
            context.fill(rect)
        }
        
        UIColor.white.setStroke()
        context.stroke(rect)
    }
    
}
