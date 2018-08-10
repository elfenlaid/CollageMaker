//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

typealias RelativePosition = CGRect

struct CollageCell {
   
    let id: UUID = UUID.init()
    let image: UIImage?
    let color: UIColor
    let imageURL: String?
    let relativePosition: RelativePosition
   
}

extension RelativePosition {
    func absolutePosition(in rect: CGRect) -> CGRect {
        return CGRect(x: origin.x * rect.width,
                      y: origin.y * rect.height,
                      width: width * rect.width,
                      height: height * rect.height)
    }
}

