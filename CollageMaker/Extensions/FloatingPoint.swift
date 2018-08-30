//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

extension FloatingPoint {
    
    static var allowableAccuracy: Self {
        return Self.ulpOfOne * 10000
    }
    
    func isApproximatelyEqual(to value: Self) -> Bool {
        return abs(self - value) < .allowableAccuracy
    }
    
    func isLessOrApproximatelyEqual(to value: Self) -> Bool {
        return isApproximatelyEqual(to: value) || self < value
    }
    
    func isGreaterOrApproximatelyEqual(to value: Self) -> Bool {
        return isApproximatelyEqual(to: value) || self > value
    }
}
