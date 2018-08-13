//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

typealias RelativePosition = CGRect

struct CollageCell {
   
    var grips: Set<Grip>
    let color: UIColor
    let id: UUID = UUID.init()
    let image: UIImage?
    let relativePosition: RelativePosition
   
}

enum Grip {
    case top
    case bottom
    case left
    case right
}

extension RelativePosition {
    func absolutePosition(in rect: CGRect) -> CGRect {
        return CGRect(x: origin.x * rect.width,
                      y: origin.y * rect.height,
                      width: width * rect.width,
                      height: height * rect.height)
    }
    
    func split(axis: Axis) -> (RelativePosition, RelativePosition) {
        switch axis {
        case .horizontal:
            return (RelativePosition(origin: origin, size: CGSize(width: size.width / 2, height: size.height)),
                    RelativePosition(origin: CGPoint(x: origin.x + size.width / 2, y: origin.y), size: CGSize(width: size.width / 2, height: size.height)))
        case .vertical:
            return (RelativePosition(origin: origin, size: CGSize(width: size.width, height: size.height / 2)),
                    RelativePosition(origin: CGPoint(x: origin.x, y: origin.y + size.height / 2), size: CGSize(width: size.width, height: size.height / 2)))
        }
    }
}
