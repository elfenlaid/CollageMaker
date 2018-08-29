//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

extension CGRect {
    
    var area: CGFloat {
        return width * height
    }
    
    func absolutePosition(in rect: CGRect) -> CGRect {
        return CGRect(x: origin.x * rect.width,
                      y: origin.y * rect.height,
                      width: width * rect.width,
                      height: height * rect.height)
    }
}

extension RelativeFrame {
    
    static var fullsized: RelativeFrame {
        return RelativeFrame(x: 0, y: 0, width: 1, height: 1)
    }
    
    var isFullsized: Bool {
        return self == RelativeFrame.fullsized
    }
    
    func split(axis: Axis) -> (RelativeFrame, RelativeFrame) {
        switch axis {
        case .horizontal:
            return (RelativeFrame(origin: origin, size: CGSize(width: size.width / 2, height: size.height)),
                    RelativeFrame(origin: CGPoint(x: origin.x + size.width / 2, y: origin.y), size: CGSize(width: size.width / 2, height: size.height)))
        case .vertical:
            return (RelativeFrame(origin: origin, size: CGSize(width: size.width, height: size.height / 2)),
                    RelativeFrame(origin: CGPoint(x: origin.x, y: origin.y + size.height / 2), size: CGSize(width: size.width, height: size.height / 2)))
        }
    }
    
    func isInBounds(_ bounds: CGRect) -> Bool {
        return maxY < bounds.maxY || abs(maxY - bounds.maxY) < .allowableAccuracy
            && maxX < bounds.maxX || abs(maxX - bounds.maxX) < .allowableAccuracy
    }
    
    func intersects(rect2: CGRect, on gripPosition: GripPosition) -> Bool {
        switch  gripPosition.axis {
        case .vertical:
            let isInHeightBounds = (self.minY > rect2.minY || abs(self.minY - rect2.minY) < .allowableAccuracy) &&
                (self.maxY < rect2.maxY || abs(self.maxY - rect2.maxY) < .allowableAccuracy)
            
            if gripPosition == .left {
                return isInHeightBounds && abs(self.maxX - rect2.minX) < .allowableAccuracy ? true : false
            } else {
                return isInHeightBounds && abs(self.minX - rect2.maxX) < .allowableAccuracy ? true : false
            }
            
        case .horizontal:
            let isInWidthBounds = (self.minX > rect2.minX || abs(self.minX - rect2.minX) < .allowableAccuracy) &&
                (self.maxX < rect2.maxX || abs(self.maxX - rect2.maxX) < .allowableAccuracy)
            
            if gripPosition == .top {
                return isInWidthBounds && abs(self.maxY - rect2.minY) < .allowableAccuracy ? true : false
            } else {
                return isInWidthBounds && abs(self.minY - rect2.maxY) < .allowableAccuracy ? true : false
            }
        }
    }
}
