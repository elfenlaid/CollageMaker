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
    
    static var brightLavender: UIColor {
        return UIColor(displayP3Red: 163.0 / 255.0, green: 138.0 / 255.0, blue: 254.0 / 255.0, alpha: 1)
    }
    
    static var collageGray: UIColor {
        return UIColor(displayP3Red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1)
    }
    
    static var collageBorder: UIColor {
        return UIColor(displayP3Red: 72.0 / 255.0, green: 72.0 / 255.0, blue: 72.0 / 255.0, alpha: 1)
    }
    
    static var collagePink: UIColor {
        return UIColor(displayP3Red: 239.0 / 255.0, green: 145.0 / 255.0, blue: 222.0 / 255.0, alpha: 1)
    }
}
