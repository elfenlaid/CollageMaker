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
        
        view.addSubview(collageView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collageView.frame = view.bounds
    }
    
    func set(collage: Collage) {
        self.collage = collage
    }
    
    private var collage: Collage? {
        didSet {
            guard let collage = collage else {
                return
            }
            
            collage.delegate = self
            
            collageView.removeFromSuperview()
            collageView = CollageView(collage: collage)
            collageView.delegate = self
            
            view.addSubview(collageView)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    private lazy var collageView = CollageView(collage: Collage(cells: []))
}


extension CollageViewController: CollageViewDelegate {
    
    func collageView(_ collageView: CollageView, tapped point: CGPoint) {
        guard let selectedCell = collage?.cell(at: point, in: collageView.frame) else {
            return
        }
        
        collage?.setSelected(cell: selectedCell)
    }
}

extension CollageViewController: CollageDelegate {
    func collage(_ collage: Collage, didChangeSelected cell: CollageCell) {
        guard let selectedCellView = collageView.cellViews.first(where: { $0.collageCell.id ==  cell.id }) else {
            return
        }
        
        collageView.setSelected(cellView: selectedCellView)
    }

}
