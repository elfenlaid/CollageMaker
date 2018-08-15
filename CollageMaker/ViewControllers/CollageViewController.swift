//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

protocol CollageViewControllerDelegate: AnyObject {
    func collageViewController(_ controller: CollageViewController, didSelect cell: CollageCell)
}

class CollageViewController: UIViewController {
    
    weak var delegate: CollageViewControllerDelegate?
    
    init(collage: Collage) {
        let collageView = CollageView(collage: collage)
        
        self.collage = collage
        self.collageView = collageView
        
        super.init(nibName: nil, bundle: nil)
        
        collage.delegate = self
        collageView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collageView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collageView.frame = view.bounds
    }
    
    func changeCollage(to: Collage) {
        self.collage = to
    }
    
    private var collage: Collage {
        didSet {
            collage.delegate = self
            
            collageView.removeFromSuperview()
            collageView = CollageView(collage: collage)
            collageView.delegate = self
            
            view.addSubview(collageView)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    private var collageView: CollageView
}


extension CollageViewController: CollageViewDelegate {
    
    func collageView(_ collageView: CollageView, tapped point: CGPoint) {
        guard let cellForPoint = collage.cell(at: point, in: collageView.frame) else {
            return
        }
        
        collage.setSelected(cell: cellForPoint)
    }
}

extension CollageViewController: CollageDelegate {
    func collage(_ collage: Collage, didChangeSelected cell: CollageCell) {
        guard let selectedCellView = collageView.cellViews.first(where: { $0.collageCell.id ==  cell.id }) else {
            return
        }
        
        collageView.setSelected(cellView: selectedCellView)
        collageView.highlightSelected()
    }

}
