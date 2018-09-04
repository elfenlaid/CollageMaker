//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit


extension UIBarButtonItem {
    static var collageCamera: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: R.image.camera_btn(), style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        btn.tintColor = .black
        
        return btn
    }()
}
