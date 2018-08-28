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
    func collage(_ collage: Collage, wantsToUpdate cells: [CollageCell])
}

struct Collage {
    
    typealias State = [CollageCell: RelativeFrame]
    weak var delegate: CollageDelegate?
    
    init(cells: [CollageCell]) {
        if cells.isEmpty {
            let initialCell = CollageCell(color: .random, image: nil, relativePosition: RelativeFrame(x: 0, y: 0, width: 1, height: 1))
            
            self.cells = [initialCell]
            self.selectedCell = initialCell
        } else {
            self.cells = cells
            self.selectedCell = cells.last ?? CollageCell(color: .white, relativePosition: .zero)
        }
        
        cells.forEach { initialState[$0] = $0.relativeFrame }
    }
    
    mutating func setSelected(cell: CollageCell) {
        guard selectedCell.id != cell.id else {
            return
        }
        
        selectedCell = cell
        delegate?.collage(self, didChangeSelected: selectedCell)
    }
    
    mutating func splitSelectedCell(by axis: Axis) {
        let (firstPosition, secondPosition) = selectedCell.relativeFrame.split(axis: axis)
        
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
    
    mutating func mergeSelectedCell() {
        for position in selectedCell.gripPositions {
            if changeSelectedCellSize(grip: position, value: position.sideChangeValue(for: selectedCell.relativeFrame), merging: true) { break }
        }
    }
    
    mutating func reset() {
        cells.removeAll()
        setPositions(from: initialState)
        delegate?.collageChanged(to: self)
    }
    
    mutating func changeSelectedCellSize(grip: GripPosition, value: CGFloat, merging: Bool = false) -> Bool {
        let changingCells = merging ? mergingCells(with: grip) : affectedCells(with: grip)
        
        guard changingCells.count > 0, check(grip, in: selectedCell) else {
            return false
        }
        
        var startState = State()
        var intermediateState = State()
        
        cells.forEach { startState[$0] = $0.relativeFrame }
        
        changingCells.forEach {
            let newPosition = $0.gripPositionRelativeTo(cell: selectedCell, grip)
            let newCellSize = calculatePosition(of: $0, for: value / 100, with: newPosition)
            
            intermediateState[$0] = newCellSize
        }
        
        var newCollage = self
        
        if merging {
            newCollage.remove(cell: selectedCell)
            newCollage.setPositions(from: intermediateState)
        }
        
        let permisionsToChangePosition = intermediateState.keys.map { isAllowed(position: intermediateState[$0] ?? RelativeFrame.zero) }
        let shouldUpdate = merging ? newCollage.isFullsized : permisionsToChangePosition.reduce (true, { $0 && $1 })
        
        if shouldUpdate {
            if merging {
                self.cells = newCollage.cells
                setSelected(cell: cells.last ?? CollageCell(color: .white, relativePosition: .zero))
                delegate?.collageChanged(to: self)
            } else {
                setPositions(from: intermediateState)
                
                if !isFullsized {
                    setPositions(from: startState)
                } else {
                    let changedCells = intermediateState.map { $0.key }
                    delegate?.collage(self, wantsToUpdate: changedCells)
                }
            }
            
            return true
        } else {
            return false
        }
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
    private var initialState = State()
    private var recentlyDeleted: CollageCell?
}


extension Collage {
    static func ==(lhs: Collage, rhs: Collage) -> Bool {
        return lhs.cells == rhs.cells
    }
    
    func cell(at relativePoint: CGPoint) -> CollageCell? {
        return cells.first(where: { $0.relativeFrame.contains(relativePoint) })
    }
    
    private mutating func setPositions(from: State) {
        var newCells =  [CollageCell]()
        let cells = from.map { $0.key }
        
        cells.forEach {
            var cell = $0
            guard let size = from[$0] else {
                return
            }
            
            cell.changeRelativeFrame(to: size)
            cell.calculateGripPositions()
            newCells.append(cell)
        }
        
        selectedCell = newCells.first(where: { $0.id == selectedCell.id}) ?? cells.last ?? CollageCell(color: .white, relativePosition: .zero)
        newCells.forEach { update(cell: $0) }
    }
    
    private func affectedCells(with gripPosition: GripPosition) -> [CollageCell] {
        return cells.filter { $0.belongsToParallelLine(on: gripPosition.axis, with: gripPosition.centerPoint(in: selectedCell)) }
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
    
    private func isAllowed(position: RelativeFrame) -> Bool {
        return min(position.width, position.height) > 0.2 ? true : false
    }
    
    private func mergingCells(with gripPosition: GripPosition) -> [CollageCell] {
        
        return cells.filter({ $0 != selectedCell }).compactMap { (cell) -> CollageCell? in
            let intersection = cell.relativeFrame.intersection(selectedCell.relativeFrame)
            let grip = cell.gripPositionRelativeTo(cell: selectedCell, gripPosition)
            
            guard cell.gripPositions.contains(grip), intersection.isLine, selectedCell.relativeFrame.line(for: gripPosition).contains(intersection) else {
                return nil
            }
            
            let line = selectedCell.relativeFrame.line(for: gripPosition)
            
            return line.maxSizeValue >= intersection.maxSizeValue ? cell : nil
        }
    }
    
    var isFullsized: Bool {
        let collageArea = RelativeFrame(x: 0, y: 0, width: 1, height: 1).area
        let cellsArea = cells.map { $0.relativeFrame.area }.reduce(0.0, { $0 + $1 })
        let cellsInBounds = cells.map { $0.relativeFrame.isInBounds(CGRect(x: 0, y: 0, width: 1, height: 1))}.reduce(true, {$0 && $1 })
        
        return cellsInBounds && abs(collageArea - cellsArea) < .ulpOfOne
    }
}

extension CGRect {
    var area: CGFloat {
        return width * height
    }
}
