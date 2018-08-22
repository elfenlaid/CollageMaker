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
            if let cell = cells.first {
                self.selectedCell = cell
            } else {
                selectedCell = CollageCell(color: .black, image: nil, relativePosition: .zero)
            }
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
    }
    
    
    func setSelected(cell: CollageCell) {
        selectedCell = cell
    }
    
    func splitSelectedCell(by axis: Axis) {
        let (firstPosition, secondPosition) = selectedCell.relativePosition.split(axis: axis)
        
        let firstCell =  CollageCell(color: selectedCell.color, image: selectedCell.image, relativePosition: firstPosition)
        let secondCell = CollageCell(color: .random, image: nil, relativePosition: secondPosition)
        
        if isAllowed(position: firstPosition) && isAllowed(position: secondPosition) {
            add(cell: firstCell)
            add(cell: secondCell)
            remove(cell: selectedCell)
            setSelected(cell: secondCell)
            
            delegate?.collageChanged(to: self)
        }
    }
    
    func mergeSelectedCell() {
        remove(cell: selectedCell)
        
        for position in selectedCell.gripPositions {
            if changeSelectedCellSize(grip: position, value: position.sideChangeValue(for: selectedCell.relativePosition), merging: true) {
                break
            }
        }
        
        if let last = cells.last {
            setSelected(cell: last)
        }
        
        print("something wrong")
    }
    
    func reset() {
        cells.removeAll()
        setPositions(from: initialState)
        delegate?.collageChanged(to: self)
    }
    
    func changeSelectedCellSize(grip: GripPosition, value: CGFloat, merging: Bool = false) -> Bool {
        guard check(grip, in: selectedCell) else {
            return false
        }
        
        let changingCells = merging ? cellsForMerging(with: grip) : affectedCells(with: grip)
        
        guard changingCells.count > 0 else {
            return false
        }
        
        var intermediateState = State()
        
        changingCells.forEach {
            guard let newPosition = $0.gripPositionRelativeTo(cell: selectedCell, grip) else {
                return
            }
            
            let newCellSize = newSize(of: $0, value: value / 100, with: newPosition)
            intermediateState[$0] = newCellSize
        }
        
        let result = intermediateState.keys.map { isAllowed(position: intermediateState[$0] ?? RelativePosition.zero) }
        let shouldUpdate = result.reduce (true, { $0 && $1 })
        
        if shouldUpdate {
            setPositions(from: intermediateState)
            delegate?.collageChanged(to: self)
            return true
        } else {
            return false
        }
        
        
    }
    
    private(set) var selectedCell: CollageCell {
        didSet {
            delegate?.collage(self, didChangeSelected: selectedCell)
            
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
            $0.key.calculateGripPositions()
            update(cell: $0.key)
        }
    }
    
    private func affectedCells(with gripPosition: GripPosition) -> [CollageCell] {
        return cells.filter { $0.belongsToParallelLine(on: gripPosition.axis, with: gripPosition.centerPoint(in: selectedCell)) }
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
    
    private func check(_ gripPosition: GripPosition, in cell: CollageCell) -> Bool {
        return cell.gripPositions.contains(gripPosition)
    }
    
    private func isAllowed(position: RelativePosition) -> Bool {
        return min(position.width, position.height) > 0.2 ? true : false
    }
    
    private func cellsForMerging(with gripPosition: GripPosition) -> [CollageCell] {
        var mergingCells = [CollageCell]()
        
        cells.forEach {
            if $0 != selectedCell {
                let intersection = $0.relativePosition.intersection(selectedCell.relativePosition)
                
                guard
                    intersection.isLine,
                    selectedCell.relativePosition.lineFor(gripPosition: gripPosition).contains(intersection),
                    let grip = $0.gripPositionRelativeTo(cell: selectedCell, gripPosition) else {
                        return
                }
                
                let line = $0.relativePosition.lineFor(gripPosition: grip)
                
                if max(line.width, line.height) <=  max(intersection.height, intersection.width) {
                    mergingCells.append($0)
                }
            }
        }
        
        return mergingCells
    }
}

extension GripPosition {
    func sideChangeValue(for position: RelativePosition) -> CGFloat {
        switch self {
        case .left:
            return position.width * 100
        case .right:
            return -position.width * 100
        case .top:
            return position.height * 100
        case .bottom:
            return -position.height * 100
        }
    }
}
