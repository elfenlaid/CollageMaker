//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class TemplateBarCollectionViewController: UICollectionViewController {
    
    init(collageTemplates: [Collage]) {
        self.templates = collageTemplates
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    
        collectionView = UICollectionView(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    private var templates: [Collage]
}
