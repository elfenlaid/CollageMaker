//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit


struct CollageCanvas {
    
    static var shared = CollageCanvas()
    
    private init() {}
    
    mutating func updateValue(cellAttributes: (UUID, CellAttributes)) {
        let (key, value) = cellAttributes
        
        self.cellAttributes.updateValue(value, forKey: key)
    }
    
    func cellsAttributes() -> [UUID: CellAttributes] {
        return cellAttributes
    }
    
    func cellAttributes(for UUID: UUID) -> CellAttributes? {
        return cellAttributes[UUID]
    }
    
    mutating func removeCell(with UUID: UUID) {
        guard let attributes = cellAttributes.removeValue(forKey: UUID) else {
            return
        }
        
        recentlyDeleted = (UUID, attributes)
    }
 
    private var recentlyDeleted: (UUID, CellAttributes)?
    private var cellAttributes: [UUID: CellAttributes] = [:]
}
