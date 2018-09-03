//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import Foundation

struct CollageState {
    var cellsRelativeFrames: [CollageCell: RelativeFrame]
    var selectedCell: CollageCell
    
    var cells: [CollageCell] {
        return cellsRelativeFrames.map { $0.key }
    }
    
    init(cellsRelativeFrames: [CollageCell: RelativeFrame] = [:], selectedCell: CollageCell = CollageCell.zeroFrame) {
        self.cellsRelativeFrames = cellsRelativeFrames
        self.selectedCell = selectedCell
    }
}
