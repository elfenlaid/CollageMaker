//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class CollageNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.barTintColor = .white
        navigationBar.setValue(true, forKey: "hidesShadow")
        
        pushViewController(rootViewController, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
