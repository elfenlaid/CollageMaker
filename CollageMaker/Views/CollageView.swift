//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

protocol CollageViewDelegate: AnyObject {
    func collageView(_ collageView: CollageView, tapped point: CGPoint)
}

class CollageView: UIView {
    
    weak var delegate: CollageViewDelegate?
    
    init() {
        super.init(frame: .zero)
        
        tapGestureRecognizer.addTarget(self, action: #selector(cellSelected(with:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    func updateFrames(for cells: [CollageCell]) {
        cellViews.forEach { cellView in
            guard let newFrame = cells.first(where: { $0.id == cellView.collageCell.id} )?.relativeFrame else {
                return
            }
            
            cellView.changeFrame(to: newFrame.absolutePosition(in: self.bounds))
            gripViews.forEach { $0.layout()
            }
        }
    }
    
    func setCollage(_ collage: Collage) {
        subviews.forEach { $0.removeFromSuperview() }
        
        self.collage = collage
        self.cellViews = collage.cells.map(CollageCellView.init)
        
        cellViews.forEach {
            $0.frame = $0.collageCell.relativeFrame.absolutePosition(in: bounds)
            addSubview($0)
        }
        
        if let cell = cellViews.first(where: {$0.collageCell.id  == collage.selectedCell.id}) {
            select(cellView: cell)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        showGrips()
    }
    
    func select(cellView: CollageCellView) {
        selectedCellView?.layer.borderColor = UIColor.white.cgColor
        selectedCellView = cellView
        selectedCellView?.layer.borderColor = UIColor.gray.cgColor
        
        showGrips()
    }
    
    private func showGrips() {
        gripViews.forEach { $0.removeFromSuperview() }
        gripViews = []
        
        selectedCellGripPositions?.forEach(layoutGripView(for: ))
    }
    
    private func layoutGripView(for position: GripPosition) {
        guard let selectedCellView = selectedCellView else {
            return
        }
        
        let gripView = GripView(with: position, in: selectedCellView)
        
        addSubview(gripView)
        gripViews.append(gripView)
    }
    
    @objc private func cellSelected(with recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: self)
        
        delegate?.collageView(self, tapped: point)
    }
    
    private var selectedCellGripPositions: Set<GripPosition>? {
        return selectedCellView?.collageCell.gripPositions
    }
    
    private var collage: Collage?
    private(set) var gripViews: [GripView] = []
    private(set) var cellViews: [CollageCellView] = []
    private(set) var selectedCellView: CollageCellView?
    private var tapGestureRecognizer = UITapGestureRecognizer()
}
