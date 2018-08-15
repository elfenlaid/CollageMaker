//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class CollageViewController: UIViewController {
    
    init(collage: Collage) {
        let collageView = CollageView(collage: collage)
        
        self.collage = collage
        self.collageView = collageView
        super.init(nibName: nil, bundle: nil)
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
            collageView.removeFromSuperview()
            collageView = CollageView(collage: collage)
            
            view.addSubview(collageView)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let point = touch.location(in: view)
        
        let selectedCell = collage.cell(at: point, in: view.frame)
        selectedCell?.changeState(to: .selected)
    }

    private var collageView: CollageView
}
