//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import XCTest
@testable import CollageMaker

class CollageTests: XCTestCase {
    
    var collage: Collage!
    
    override func setUp() {
        super.setUp()
        
        collage = Collage()
    }
    
    override func tearDown() {
        collage = nil
        
        super.tearDown()
    }
    
    func testCollageCantDeleteLastCell() {
        while collage.cells.count != 1 {
            collage.deleteSelectedCell()
        }
        
        collage.deleteSelectedCell()
        XCTAssertEqual(collage.cells.count, 1)
    }
    
    func testCellSizeIsInBounds() {
        var cellUnderTest = collage.selectedCell
        
        cellUnderTest.changeRelativeFrame(to: RelativeFrame(x: 0, y: 0, width: 100, height: 200))
        
        XCTAssertTrue(cellUnderTest.isAllowed(relativeFrame: cellUnderTest.relativeFrame))
    }
    
    func testCollageIsAlwaysFullsized() {
        let cell = CollageCell(color: .blue, relativeFrame: .fullsized)
        let secondCell = CollageCell(color: .blue, relativeFrame: .fullsized)
        
        collage = Collage(cells: [cell, secondCell])
       
        XCTAssertTrue(collage.isFullsized)
    }
}
