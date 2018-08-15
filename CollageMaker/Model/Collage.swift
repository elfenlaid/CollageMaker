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
}

class Collage {
    
    weak var delegate: CollageDelegate?
    
    init(cells: [CollageCell]) {
        if cells.count < 1 {
            let initialCell = CollageCell(color: .lightGray, image: nil, relativePosition: RelativePosition(x: 0, y: 0, width: 1, height: 1))
            
            self.cells = [initialCell]
            self.selectedCell = initialCell
        } else {
            self.cells = cells
            self.selectedCell = cells.first
        }
    }
    
    func setSelected(cell: CollageCell) {
        selectedCell = cell
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
    
    func split(cell: CollageCell, by axis: Axis) {
        guard let cell = cells.first(where: { $0.id == cell.id }) else {
            return
        }
        
        let (firstPosition, secondPosition) = cell.relativePosition.split(axis: axis)
        
        let firstCell =  CollageCell(color: cell.color, image: cell.image, relativePosition: firstPosition)
        let secondCell = CollageCell(color: .gray, image: nil, relativePosition: secondPosition)
        
        add(cell: firstCell)
        add(cell: secondCell)
        
        remove(cell: cell)
    }
    
    func cell(at point: CGPoint, in rect: CGRect) -> CollageCell? {
        let relativePoint = CGPoint(x: point.x / rect.width,
                                    y: point.y / rect.height)
        
        return cells.first(where: { $0.relativePosition.contains(relativePoint) })
    }
    
    private(set) var selectedCell: CollageCell? {
        didSet {
            if let cell = selectedCell {
                delegate?.collage(self, didChangeSelected: cell)
            }
        }
    }
    
    private var recentlyDeleted: CollageCell?
    private(set) var cells: [CollageCell] = []
}

extension Collage {
    static func ==(lhs: Collage, rhs: Collage) -> Bool {
        return lhs.cells == rhs.cells
    }
}
