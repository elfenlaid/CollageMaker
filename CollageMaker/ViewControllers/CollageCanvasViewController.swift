//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

class CollageCanvasViewController: UIViewController {
    
    init(with: CollageCanvas = CollageCanvas.shared) {
        self.canvas = with
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(initialCell)
        makeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showCanvas(canvas: canvas)
    }
    
    func makeConstraints() {
        initialCell.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
    }
    
    func splitCell(by axis: CanvasCell.Axis) {
        
    }
    
    func showCanvas(canvas: CollageCanvas) {
        let noCanvasProvided = canvas.cellsAttributes().count <= 0
        
        if noCanvasProvided {
            let cellAttributes = CellAttributes(isInitial: true, state: .selected)
            initialCell = CanvasCell(attributes: cellAttributes)
        } else {
            
        }
    }
    
    private var initialCell = CanvasCell(attributes: CellAttributes(isInitial: true, state: .deselected))
    private var selectedCell: CanvasCell?
    private var canvas: CollageCanvas
}


extension CollageCanvasViewController: CanvasCellDelegate {
    func canvasCell(_ cell: CanvasCell, switchedTo state: CanvasCell.State) {
        if state == .selected {
            selectedCell?.updateAttributes(with: CellAttributes(isInitial: true, state: .deselected))
            selectedCell = cell
        }
    }
}
