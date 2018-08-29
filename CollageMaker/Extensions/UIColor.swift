//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

extension UIColor {
    
    static var random: UIColor {
        let red = CGFloat(arc4random_uniform(255)) / 255.0
        let green = CGFloat(arc4random_uniform(255)) / 255.0
        let blue = CGFloat(arc4random_uniform(255)) / 255.0
 
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static var collagePurple: UIColor {
        return UIColor(displayP3Red: 161.0 / 255.0, green: 142.0 / 255.0, blue: 243.0 / 255.0, alpha: 1)
    }
}
