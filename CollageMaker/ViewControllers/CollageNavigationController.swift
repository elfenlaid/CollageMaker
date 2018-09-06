//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class CollageNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = .white
        navigationBar.tintColor = .black
        navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
