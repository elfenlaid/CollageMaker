//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class GripView: UIView {
    
    init(with position: GripPosition, in cellView: CollageCellView) {
        self.position = position
        self.associatedCellView = cellView
        super.init(frame: .zero)
        
        backgroundColor = .brightLavender
        
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented ")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    func layout() {
        let verticalSize = CGSize(width: 7, height: associatedCellView.frame.height / 3)
        let horizontalSize = CGSize(width: associatedCellView.frame.width / 3, height: 7)
        
        switch position {
        case .left:
            center = CGPoint(x: associatedCellView.frame.minX, y: associatedCellView.frame.midY)
            bounds.size = verticalSize
        case .right:
            center = CGPoint(x: associatedCellView.frame.maxX, y: associatedCellView.frame.midY)
            bounds.size = verticalSize
        case .top:
            center = CGPoint(x: associatedCellView.frame.midX, y: associatedCellView.frame.minY)
            bounds.size = horizontalSize
        case .bottom:
            center = CGPoint(x: associatedCellView.frame.midX, y: associatedCellView.frame.maxY)
            bounds.size = horizontalSize
        }
        
        layer.cornerRadius = min(frame.height, frame.width) / 2
    }
    
    private(set) var position: GripPosition
    private var associatedCellView: CollageCellView
}
