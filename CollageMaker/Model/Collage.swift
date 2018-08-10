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
        
        let (left, right) = cell.relativePosition.split(axis: axis)
        let splitedCells = [
            CollageCell(image: cell.image, color: cell.color, imageURL: cell.imageURL, relativePosition: left),
            CollageCell(image: nil, color: .white, imageURL: nil, relativePosition: right)
        ]
        
        remove(cell: cell)
        splitedCells.forEach { add(cell: $0) }
    }
    
    private var recentlyDeleted: CollageCell?
    private var cells: [CollageCell] = []
}


extension RelativePosition {
    func split(axis: Axis) -> (RelativePosition, RelativePosition) {
        switch axis {
        case .horizontal:
            return (RelativePosition(origin: origin, size: CGSize(width: size.width / 2, height: size.height)),
                    RelativePosition(origin: CGPoint(x: size.width / 2, y: origin.y), size: CGSize(width: size.width / 2, height: size.height)))
        case .vertical:
            return (RelativePosition(origin: origin, size: CGSize(width: size.width, height: size.height / 2)),
                    RelativePosition(origin: CGPoint(x: origin.x, y: size.height / 2), size: CGSize(width: size.width, height: size.height / 2)))
        }
    }
}
