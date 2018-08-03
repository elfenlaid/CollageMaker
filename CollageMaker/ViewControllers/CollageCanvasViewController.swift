//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class CollageCanvasViewController: UIViewController {
    
    init(canvas: CollageCanvas) {
        self.collageCanvas = canvas
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    
    
    private var selectedCell: CanvasCell?
    private let collageCanvas: CollageCanvas
}


extension CollageCanvasViewController: CanvasCellDelegate {
    func canvasCell(_ cell: CanvasCell, switchedTo state: CanvasCell.State) {
        print(state)
    }
}
