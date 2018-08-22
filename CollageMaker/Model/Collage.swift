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
}

class Collage {
    
    typealias State = [CollageCell: RelativePosition]
    weak var delegate: CollageDelegate?
    
    init(cells: [CollageCell]) {
        if cells.count < 1 {
            let initialCell = CollageCell(color: .random, image: nil, relativePosition: RelativePosition(x: 0, y: 0, width: 1, height: 1))
            
            self.cells = [initialCell]
            self.selectedCell = initialCell
        } else {
            self.cells = cells
            self.selectedCell = cells.first
        }
        
        cells.forEach { initialState[$0] = $0.relativePosition }
    }
    
    func add(cell: CollageCell) {
        if !cells.contains(cell) {
            cells.append(cell)
        }
    }
    
    func remove(cell: CollageCell) {
        guard cells.count > 1 else {
            return
        }
        
        recentlyDeleted = cell
        cells = cells.filter { $0.id != cell.id }
    }
    
    func update(cell: CollageCell) {
        remove(cell: cell)
        add(cell: cell)
        
        delegate?.collageChanged(to: self)
    }
    
    
    func setSelected(cell: CollageCell) {
        selectedCell = cell
    }
    
    func splitSelectedCell(by axis: Axis) {
        guard let cell = selectedCell else {
            return
        }
        
        let (firstPosition, secondPosition) = cell.relativePosition.split(axis: axis)
        
        let firstCell =  CollageCell(color: cell.color, image: cell.image, relativePosition: firstPosition)
        let secondCell = CollageCell(color: .random, image: nil, relativePosition: secondPosition)
        
        if isAllowed(position: firstPosition) && isAllowed(position: secondPosition) {
            add(cell: firstCell)
            add(cell: secondCell)
            remove(cell: cell)
            setSelected(cell: secondCell)
            
            delegate?.collageChanged(to: self)
        }
    }
    
    func mergeSelectedCell() {
        guard let cell = selectedCell else {
            return
        }
        
        remove(cell: cell)
        changeSize(grip: cell.gripPositions.first!, value: -cell.relativePosition.height * 100)
        
        if let last = cells.last {
            setSelected(cell: last)
        }
    }
    
    func reset() {
        setPositions(from: initialState)
        delegate?.collageChanged(to: self)
    }
    
    func changeSize(grip: GripPosition, value: CGFloat) {
        let changingCells = affectedCells(with: grip)
        var intermediateState = State()
        
        changingCells.forEach {
            guard let cell = selectedCell, let newPosition = $0.gripPositionRelativeTo(cell: cell, grip) else {
                return
            }
            
            let newCellSize = newSize(of: $0, value: value / 100, with: newPosition)
            intermediateState[$0] = newCellSize
        }
        
        let result = intermediateState.keys.map { isAllowed(position: intermediateState[$0] ?? RelativePosition.zero) }
        let shouldUpdate = result.reduce (true, { $0 && $1 })
        
        if shouldUpdate { setPositions(from: intermediateState) }
    }
    
    private(set) var selectedCell: CollageCell? {
        didSet {
            if let cell = selectedCell {
                delegate?.collage(self, didChangeSelected: cell)
            }
        }
    }
    
    private(set) var cells: [CollageCell] = []
    private var initialState = State()
    private var recentlyDeleted: CollageCell?
}


extension Collage {
    static func ==(lhs: Collage, rhs: Collage) -> Bool {
        return lhs.cells == rhs.cells
    }
    
    func cell(at point: CGPoint, in rect: CGRect) -> CollageCell? {
        let relativePoint = CGPoint(x: point.x / rect.width,
                                    y: point.y / rect.height)
        
        return cells.first(where: { $0.relativePosition.contains(relativePoint) })
    }
    
    private func setPositions(from: State) {
        from.keys.forEach { if let newSize = from[$0] { $0.relativePosition = newSize } }
        
        from.forEach {
            update(cell: $0.key)
            $0.key.calculateGripPositions()
        }
    }
    
    private func affectedCells(with gripPosition: GripPosition) -> [CollageCell] {
        guard let cell = selectedCell else {
            return []
        }
        
        return cells.filter { $0.belongsToParallelLine(on: gripPosition.axis, with: gripPosition.centerPoint(in: cell)) }
    }
    
    private func newSize(of cell: CollageCell, value: CGFloat, with gripPosition: GripPosition) -> RelativePosition {
        guard cell.gripPositions.contains(gripPosition) else {
            return cell.relativePosition
        }
        
        var newValue = cell.relativePosition
        
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
    
    private func isAllowed(position: RelativePosition) -> Bool {
        return min(position.width, position.height) > 0.2 ? true : false
    }
    
}
