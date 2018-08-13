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
    
    func allCells() -> [CollageCell] {
        return cells
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
   
        let splitedCells = [
            CollageCell(grips: cell.grips, color: cell.color, image: cell.image, relativePosition: first),
            CollageCell(grips: [], color: .gray, image: nil, relativePosition: second)
        ]
        
        remove(cell: cell)
        splitedCells.forEach { add(cell: $0) }
    }
    
    private var recentlyDeleted: CollageCell?
    private var cells: [CollageCell] = []
}
