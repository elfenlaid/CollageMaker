//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

typealias RelativePosition = CGRect

struct CollageCell {

    let color: UIColor
    let id: UUID = UUID.init()
    let image: UIImage?
    var relativePosition: RelativePosition
    
    mutating func calculateGripPositions(){
        guard relativePosition.isFullsized == false else { return }
        
        if !relativePosition.hasMaximumWidth {
            if relativePosition.minX > 0 { gripPositions.insert(.left) }
            if relativePosition.maxX < 1 { gripPositions.insert(.right) }
        }
        
        if !relativePosition.hasMaximumHeight {
            if relativePosition.minY > 0 { gripPositions.insert(.top) }
            if relativePosition.maxY < 1 { gripPositions.insert(.bottom) }
        }
    }
    
    private(set) var gripPositions: Set<GripPosition> = []
}

enum GripPosition {
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
    
    var isFullsized: Bool {
        return self == CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    
    var hasMaximumHeight: Bool {
        return self.height == 1
    }
    
    var hasMaximumWidth: Bool {
        return self.width == 1
    }
}
