//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

enum Axis {
    case horizontal
    case vertical
}

protocol CollageDelegate: AnyObject {
    func collage(_ collage: Collage, didChangeSelected cell: CollageCell)
    func collageChanged(to collage: Collage)
    func collage(_ collage: Collage, changed state: CollageState)
    func collage(_ collage)
}

struct Collage {
    
    weak var delegate: CollageDelegate?
    
    init(cells: [CollageCell] = []) {
        self.cells = cells
        self.selectedCell = cells.last ?? CollageCell.null
        
        cells.forEach { initialState.cellsRelativeFrames[$0] = $0.relativeFrame }
        initialState.selectedCell = selectedCell
        
        guard isFullsized else {
            let initialCell = CollageCell(color: .random, image: nil, relativeFrame: RelativeFrame.fullsized)
            
            self.cells = [initialCell]
            self.selectedCell = initialCell
            initialState = CollageState(cellsRelativeFrames: [initialCell: initialCell.relativeFrame], selectedCell: initialCell)
            
            return
        }
    }
    
    mutating func setSelected(cell: CollageCell) {
        guard selectedCell.id != cell.id else {
            return
        }
        
        selectedCell = cells.first(where: { $0.id == cell.id }) ?? CollageCell.null
        
        delegate?.collage(self, didChangeSelected: selectedCell)
    }
    
    mutating func splitSelectedCell(by axis: Axis) {
        let (firstFrame, secondFrame) = selectedCell.relativeFrame.split(axis: axis)
        
        let firstCell =  CollageCell(color: selectedCell.color, image: selectedCell.image, relativeFrame: firstFrame)
        let secondCell = CollageCell(color: .random, image: nil, relativeFrame: secondFrame)
        
        if firstCell.isAllowed(firstFrame) && secondCell.isAllowed(secondFrame) {
            add(cell: firstCell)
            add(cell: secondCell)
            remove(cell: selectedCell)
            setSelected(cell: secondCell)
            
            delegate?.collageChanged(to: self)
        }
    }
    
    mutating func deleteSelectedCell() {
        for position in selectedCell.gripPositions {
            if changeSelectedCellSize(grip: position, value: position.sideChangeValue(for: selectedCell.relativeFrame), merging: true) { break }
        }
    }
    
    mutating func addImageToSelectedCell(_ image: UIImage) {
        selectedCell.addImage(image)
        update(cell: selectedCell)
        
        delegate?.collageChanged(to: self)
    }
    
    mutating func reset() {
        cells.removeAll()
        setPositions(from: initialState)
        delegate?.collageChanged(to: self)
    }
    
    @discardableResult
    mutating func changeSelectedCellSize(grip: GripPosition, value: CGFloat, merging: Bool = false) -> Bool {
        let changingCells = merging ? mergingCells(with: grip) : affectedCells(with: grip)
        
        guard changingCells.count > 0, check(grip, in: selectedCell) else {
            return false
        }
        
        var startState = CollageState(selectedCell: selectedCell)
        var intermediateState = CollageState()
        
        cells.forEach { startState.cellsRelativeFrames[$0] = $0.relativeFrame }
        
        changingCells.forEach {
            let changeGrip = $0.gripPositionRelativeTo(cell: selectedCell, grip)
            let newCellSize = calculatePosition(of: $0, for: value, with: changeGrip)
            
            intermediateState.cellsRelativeFrames[$0] = newCellSize
        }
        
        if merging { remove(cell: selectedCell) }
        intermediateState.selectedCell = merging ? intermediateState.cells.last ?? CollageCell.null : selectedCell
        
        setPositions(from: intermediateState)
        
        let permisionsToChangePosition = intermediateState.cells.map { $0.isAllowed(intermediateState.cellsRelativeFrames[$0] ?? RelativeFrame.zero) }
        let shouldUpdate = isFullsized && permisionsToChangePosition.reduce (true, { $0 && $1 })
        
        guard shouldUpdate else {
            setPositions(from: startState)
            delegate?.collageChanged(to: self)
            
            return false
        }
        
        merging ? delegate?.collageChanged(to: self) : delegate?.collage(self, changed: intermediateState)
        
        return true
    }
    
    private mutating func add(cell: CollageCell) {
        if !cells.contains(cell) {
            cells.append(cell)
        }
    }
    
    private mutating func remove(cell: CollageCell) {
        recentlyDeleted = cell
        cells = cells.filter { $0.id != cell.id }
    }
    
    private mutating func update(cell: CollageCell) {
        remove(cell: cell)
        add(cell: cell)
    }
    
    var selectedCell: CollageCell
    private(set) var cells: [CollageCell]
    private var initialState = CollageState()
    private var recentlyDeleted: CollageCell?
}


extension Collage {
    
    var isFullsized: Bool {
        let collageArea = RelativeFrame.fullsized.area
        let cellsArea = cells.map { $0.relativeFrame.area }.reduce(0.0, { $0 + $1 })
        let cellsInBounds = cells.map { $0.relativeFrame.isInBounds(.fullsized) }.reduce(true, {$0 && $1 })
   
        return cellsInBounds && collageArea.isApproximatelyEqual(to: cellsArea)
    }
    
    func cell(at relativePoint: CGPoint) -> CollageCell? {
        return cells.first(where: { $0.relativeFrame.contains(relativePoint) })
    }
    
    static func ==(lhs: Collage, rhs: Collage) -> Bool {
        return lhs.cells == rhs.cells
    }
    
    private mutating func setPositions(from state: CollageState) {
        var newCells =  [CollageCell]()
        
        state.cells.forEach {
            var cell = $0
            guard let size = state.cellsRelativeFrames[$0] else {
                return
            }
            
            cell.changeRelativeFrame(to: size)
            cell.calculateGripPositions()
            newCells.append(cell)
        }
        
        newCells.forEach { update(cell: $0) }
        selectedCell = cells.first(where: { $0.id == state.selectedCell.id }) ?? CollageCell.null
    }
    
    private func calculatePosition(of cell: CollageCell, for value: CGFloat, with gripPosition: GripPosition) -> RelativeFrame {
        guard check(gripPosition, in: cell) else {
            return cell.relativeFrame
        }
        
        var newValue = cell.relativeFrame
        
        switch gripPosition {
        case .left:
            newValue.origin.x += value
            newValue.size.width -= value
        case .right:
            newValue.size.width += value
        case .top:
            newValue.origin.y += value
            newValue.size.height -= value
        case .bottom:
            newValue.size.height += value
        }
        
        return newValue
    }
    
    private func check(_ gripPosition: GripPosition, in cell: CollageCell) -> Bool {
        return cell.gripPositions.contains(gripPosition)
    }
    
    private func affectedCells(with gripPosition: GripPosition) -> [CollageCell] {
        return cells.filter { $0.belongsToParallelLine(on: gripPosition.axis, with: gripPosition.centerPoint(in: selectedCell)) }
    }
    
    private func mergingCells(with gripPosition: GripPosition) -> [CollageCell] {
        return cells.filter({ $0 != selectedCell }).compactMap { (cell) -> CollageCell? in
            return cell.relativeFrame.intersects(rect2: selectedCell.relativeFrame, on: gripPosition) ? cell : nil
        }
    }
}
