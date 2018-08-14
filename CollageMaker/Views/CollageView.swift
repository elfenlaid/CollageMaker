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
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        
        addGestureRecognizer(tapGestureRecognizer)
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
    
    func cellView(for point: CGPoint) -> CollageCellView? {
        let cell = cellViews.first(where: { $0.frame.contains(point) })
        return cell
    }
    
    @objc private func tapped(recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: self)
        let selectedCell = cellView(for: point)
        
        self.selectedCell = selectedCell
    }
    
    private var collage: Collage
    private var cellViews: [CollageCellView]
    private var tapGestureRecognizer = UITapGestureRecognizer()
    private(set) var selectedCell: CollageCellView?
}
