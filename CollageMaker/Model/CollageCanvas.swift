//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

struct CollageCanvas {
    
    init(cells: [CanvasCell]) {
        self.canvasCells = cells
    }
    
    mutating func dropCell(with id: UUID) {
        let cell = canvasCells.compactMap { $0.id == id ? $0 : nil }
        defer { recentlyDeleted = cell }
        
        canvasCells = canvasCells.filter { $0.id != id }
    }
    
    mutating func addCell(_ cell: CanvasCell) {
        canvasCells.append(cell)
    }
    
    mutating func restoreRecentlyDeletedCell() {
        defer { recentlyDeleted = [] }
        canvasCells.append(contentsOf: recentlyDeleted)
    }
    
    private var recentlyDeleted: [CanvasCell] = []
    private var canvasCells: [CanvasCell] = []
}
