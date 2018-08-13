//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class CollageRenderer {
    
    func renderImage(from collage: Collage, with size: CGSize) -> UIImage? {
        let format = UIGraphicsImageRendererFormat(for: .init(userInterfaceIdiom: .pad))
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        
        return renderer.image { context in
            collage.allCells().forEach { render(cell: $0, in: context) }
        }
    }
    
    func render(cell: CollageCell, in context: UIGraphicsRendererContext) {
        let rect = cell.relativePosition.absolutePosition(in: context.format.bounds)
        
        if let image = cell.image?.cgImage {
            context.cgContext.draw(image, in: rect)
        } else {
            UIColor.white.setFill()
            context.fill(rect)
        }
    }

}
