//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class CanvasCellContainer: UIView {
    var numberOfCells: Int = 0
    
    init(cell: CanvasCell) {
        self.cell = cell
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Nt implemented")
    }
    
    enum Axis {
        case horizontal
        case vertical
    }
    
    func splitContainer(by axis: Axis) {
        let newCell = CanvasCell(state: .selected)
        
        stackView.addArrangedSubview(newCell)
        stackView.distribution = .fillEqually
        
        switch axis {
        case .vertical: stackView.axis = .vertical
        case .horizontal: stackView.axis = .horizontal
        }
    }
    private lazy var stackView: UIStackView = {
        let imageViewsStackView = UIStackView(arrangedSubviews: [cell])
        
        return imageViewsStackView
    }()
    
    private let cell: CanvasCell
}
