//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import Foundation

struct CellAttributes {
    var isInitial: Bool
    var state: CanvasCell.State
    var imageURL: String?
    var parentCellID: UUID?
    var childCellsIDs: [UUID]?
    var childCellsLayoutAxis: CanvasCell.Axis?
    
    init(isInitial: Bool, state: CanvasCell.State, imageURL: String? = nil, parentCellID: UUID? = nil, childCellsIDs: [UUID]? = nil, childCellsLayoutAxis: CanvasCell.Axis? = nil) {
        self.isInitial = isInitial
        self.state = state
        self.imageURL = imageURL
        self.parentCellID = parentCellID
        self.childCellsIDs = childCellsIDs
        self.childCellsLayoutAxis = childCellsLayoutAxis
    }
}
