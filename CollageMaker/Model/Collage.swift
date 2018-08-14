//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

enum Axis {
    case horizontal
    case vertical
}

struct Collage {
    
    init(cells: [CollageCell]) {
        self.cells = cells
    }
    
    mutating func add(cell: CollageCell) {
        cells.append(cell)
    }
    
    mutating func remove(cell: CollageCell) {
        cells = cells.filter { $0.id != cell.id }
    }
    
    mutating func split(cell: CollageCell, by axis: Axis) {
        guard let cell = cells.first(where: { $0.id == cell.id }) else {
            return
        }
        
        let (first, second) = cell.relativePosition.split(axis: axis)
        
        var firstCell =  CollageCell(color: cell.color, image: cell.image, relativePosition: first, gripPositions: [])
        var secondCell = CollageCell(color: .gray, image: nil, relativePosition: second, gripPositions: [])
        
        firstCell.calculateGripPositions()
        secondCell.calculateGripPositions()
        
        remove(cell: cell)
        
        add(cell: firstCell)
        add(cell: secondCell)
    }
    
    
    private var recentlyDeleted: CollageCell?
    private(set) var cells: [CollageCell] = []
}
