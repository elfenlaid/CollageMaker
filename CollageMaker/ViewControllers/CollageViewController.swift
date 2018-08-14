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
    
    private var collageView: CollageView
}
