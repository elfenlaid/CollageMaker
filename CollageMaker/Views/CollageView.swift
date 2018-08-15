//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class CollageView: UIView {
    
    init(collage: Collage, width: CGFloat = 0) {
        self.collage = collage
        self.cellViews = collage.cells.map(CollageCellView.init)

        super.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: width)))

        cellViews.forEach { addSubview($0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellViews.forEach { $0.frame = $0.collageCell.relativePosition.absolutePosition(in: bounds) }
    }

    private var collage: Collage
    private var cellViews: [CollageCellView]
    private(set) var selectedCell: CollageCellView?
}
