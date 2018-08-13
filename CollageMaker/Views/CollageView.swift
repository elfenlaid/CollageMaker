//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class CollageView: UIView {
    
    init(collage: Collage, width: CGFloat = 0) {
        self.collage = collage
        self.cellViews = collage.allCells().map(CollageCellView.init)

        super.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: width)))
        
        cellViews.forEach { addSubview($0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellViews.forEach(layout(_:))
    }
    
    func layout(_ cellView: CollageCellView) {
        cellView.frame = cellView.collageCell.relativePosition.absolutePosition(in: bounds)
    }
    
    private var collage: Collage
    private var cellViews: [CollageCellView]
    private var selectedCell: CollageCellView?
}
