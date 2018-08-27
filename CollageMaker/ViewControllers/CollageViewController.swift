//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

protocol CollageViewControllerDelegate: AnyObject {
    func collageViewController(_ controller: CollageViewController, didSelect cell: CollageCell)
}

class CollageViewController: UIViewController {
    
    weak var delegate: CollageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGestureRecognizer.addTarget(self, action: #selector(changeDimension(with:)))
        
        collageView.delegate = self
        view.addSubview(collageView)
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collageView.frame = view.bounds
    }
    
    func set(collage: Collage) {
        self.collage = collage
    }
    
    
    @objc private func changeDimension(with recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: view)
        
        switch recognizer.state {
        case .began:
            startPoint = point
            let frame = CGRect(x: startPoint.x - 20, y: startPoint.y - 20, width: 40, height: 40)
            
            selectedGrip = collageView.gripViews.first(where: {$0.frame.intersects(frame)})?.position
        case .cancelled:
            print("Cancelled")
        case .changed:
            guard let grip = selectedGrip else {
                return
            }
            
            let value = grip.axis == .horizontal ? point.y - startPoint.y : point.x - startPoint.x
   
            collage.changeSelectedCellSize(grip: grip, value: value)
        case .ended: print("Ended")
            startPoint = point
        default: break
        }
        startPoint = point
    }
    
    var collage: Collage = Collage(cells: []) {
        didSet {
            collage.delegate = self
            
            collageView.setNeedsLayout()
            collageView.layoutIfNeeded()
            
            collageView.updateView(with: collage)
        }
    }
    
    private lazy var collageView = CollageView(collage: Collage(cells: []))
    private var panGestureRecognizer = UIPanGestureRecognizer()
    private var selectedGrip: GripPosition?
    var startPoint = CGPoint.zero
}


extension CollageViewController: CollageViewDelegate {
    
    func collageView(_ collageView: CollageView, tapped point: CGPoint) {
        let relativePoint = CGPoint(x: point.x / collageView.frame.width,
                                    y: point.y / collageView.frame.height)
        
        guard let selectedCell = collage.cell(at: relativePoint) else {
            return
        }
        
        collage.setSelected(cell: selectedCell)
    }
}

extension CollageViewController: CollageDelegate {
    
    func collageChanged(to collage: Collage) {
        set(collage: collage)
    }
    
    func collage(_ collage: Collage, didChangeSelected cell: CollageCell) {
        guard let selectedCellView = collageView.cellViews.first(where: { $0.collageCell.id ==  cell.id }) else {
            return
        }
        
        collageView.setSelected(cellView: selectedCellView)
    }
    
}
