//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

typealias RelativePosition = CGRect

class CollageCell {
    
    let color: UIColor
    let id: UUID = UUID.init()
    let image: UIImage?
    var relativePosition: RelativePosition
    
    init(color: UIColor, image: UIImage? = nil, relativePosition: RelativePosition) {
        self.color = color
        self.image = image
        self.relativePosition = relativePosition
        
        calculateGripPositions()
    }
    
    private func calculateGripPositions(){
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

extension CollageCell: Equatable {
    static func ==(lhs: CollageCell, rhs: CollageCell) -> Bool {
        return lhs.color == rhs.color && lhs.gripPositions == rhs.gripPositions && lhs.id == rhs.id && lhs.image == rhs.image
    }
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
        return abs(height - 1.0) < .ulpOfOne
    }
    
    var hasMaximumWidth: Bool {
        return abs(width - 1.0) < .ulpOfOne
    }
    
}
