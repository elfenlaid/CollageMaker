//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class CollageCellView: UIView {
    
    init(collageCell: CollageCell) {
        self.collageCell = collageCell
        super.init(frame: collageCell.relativePosition)
        
        addSubview(imageView)
        
        imageView.frame = bounds
        imageView.image = collageCell.image
        backgroundColor = collageCell.color
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func set(image: UIImage) {
        imageView.image = image
    }
    
    private let imageView = UIImageView()
    private (set) var collageCell: CollageCell
}
