//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

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
    
    func updateSelectedCellView(with collageCell: CollageCell) {
        cellViews.first(where: { $0.collageCell.id == selectedCellView?.collageCell.id })?.updateCollageCell(collageCell)
    }
    
    func changeFrames(from: CollageState) {
        from.cells.forEach { cell in
            guard let size = from.cellsRelativeFrames[cell] else {
                return
            }
            
            cellViews.first(where: { $0.collageCell.id == cell.id })?.changeFrame(to: size.absolutePosition(in: self.bounds))
            gripViews.forEach { $0.layout() }
        }
    }
    
    func setCollage(_ collage: Collage) {
        subviews.forEach { $0.removeFromSuperview() }
        
        self.collage = collage
        self.cellViews = collage.cells.map { CollageCellView(collageCell: $0, frame: $0.relativeFrame.absolutePosition(in: self.bounds)) }
        
        cellViews.forEach {
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
        selectedCellView?.layer.borderWidth = 0
        selectedCellView = cellView
        selectedCellView?.layer.borderWidth = 2
        selectedCellView?.layer.borderColor = UIColor.brightLavender.cgColor
        
        showGrips()
    }

    func fadeIn() {
        alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
        }
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
