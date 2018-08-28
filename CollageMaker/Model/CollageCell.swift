//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

typealias RelativeFrame = CGRect

struct CollageCell: Equatable, Hashable {
    
    var hashValue: Int {
        return id.hashValue
    }
    
    
    let color: UIColor
    let id: UUID = UUID.init()
    let image: UIImage?
    var relativeFrame: RelativeFrame
    
    init(color: UIColor, image: UIImage? = nil, relativePosition: RelativeFrame) {
        self.color = color
        self.image = image
        self.relativeFrame = relativePosition
        
        calculateGripPositions()
    }
    
    func belongsToParallelLine(on axis: Axis, with point: CGPoint) -> Bool {
        if axis == .horizontal {
            return abs(point.y - relativeFrame.minY) < .ulpOfOne || abs(point.y - relativeFrame.maxY) < .ulpOfOne
        } else if axis == .vertical {
            return abs(point.x - relativeFrame.minX) < .ulpOfOne || abs(point.x - relativeFrame.maxX) < .ulpOfOne
        } else {
            return false
        }
    }
    
    mutating func changeRelativeFrame(to: RelativeFrame) {
        relativeFrame = to
    }
    
    mutating func calculateGripPositions(){
        gripPositions.removeAll()
        
        guard relativeFrame.isFullsized == false else {
            return
        }
        
        if abs(relativeFrame.minX) > .ulpOfOne { gripPositions.insert(.left) }
        if abs(relativeFrame.maxX - 1) > .ulpOfOne { gripPositions.insert(.right) }
        if abs(relativeFrame.minY) > .ulpOfOne { gripPositions.insert(.top) }
        if abs(relativeFrame.maxY - 1) > .ulpOfOne { gripPositions.insert(.bottom) }
        
    }
    
    func gripPositionRelativeTo(cell: CollageCell, _ gripPosition: GripPosition) -> GripPosition {
        guard cell != self else {
            return gripPosition
        }
        
        if gripPosition.axis == .horizontal {
            return self.relativeFrame.midY < gripPosition.centerPoint(in: cell).y ? .bottom : .top
        } else {
            return self.relativeFrame.midX < gripPosition.centerPoint(in: cell).x ? .right : .left
        }
    }
    
    private(set) var gripPositions: Set<GripPosition> = []
}

enum GripPosition {
    case top
    case bottom
    case left
    case right
    
    func centerPoint(in cell: CollageCell) -> CGPoint {
        switch self {
        case .left: return CGPoint(x: cell.relativeFrame.minX, y: cell.relativeFrame.midY)
        case .right: return CGPoint(x: cell.relativeFrame.maxX, y: cell.relativeFrame.midY)
        case .top: return CGPoint(x: cell.relativeFrame.midX, y: cell.relativeFrame.minY)
        case .bottom: return CGPoint(x: cell.relativeFrame.midX, y: cell.relativeFrame.maxY)
        }
    }
    
    var axis: Axis {
        switch self {
        case .left, .right: return .vertical
        case .top, .bottom: return .horizontal
        }
    }
}

extension GripPosition {
    func sideChangeValue(for position: RelativeFrame) -> CGFloat {
        switch self {
        case .left:
            return position.width * 100
        case .right:
            return -position.width * 100
        case .top:
            return position.height * 100
        case .bottom:
            return -position.height * 100
        }
    }
}

extension RelativeFrame {
    
    func absolutePosition(in rect: CGRect) -> CGRect {
        return CGRect(x: origin.x * rect.width,
                      y: origin.y * rect.height,
                      width: width * rect.width,
                      height: height * rect.height)
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
    
    var isFullsized: Bool {
        return self == CGRect(x: 0, y: 0, width: 1, height: 1)
    }
}

extension CGRect {
 
    var isLine: Bool {
        return (width.isZero && height > 0) || (height.isZero && width > 0)
    }
    
    func isInBounds(_ bounds: CGRect) -> Bool {
        return maxX <= bounds.maxX && maxY <= bounds.maxY
    }
    
    var lineAxis: Axis? {
        guard isLine else {
            return nil
        }
        
        return width.isZero ? .vertical : .horizontal
    }
    
    var maxSizeValue: CGFloat {
        return max(width, height)
    }
    
    func line(for gripPosition: GripPosition) -> CGRect {
        switch gripPosition {
        case .left: return zeroWidthFullHeightLeftPosition
        case .right: return zeroWidthFullHeightRightPosition
        case .top: return zeroHeightFullWidthTopPosition
        case .bottom: return zeroHeightFullWidthBottomPosition
        }
    }
    
    var zeroHeightFullWidthTopPosition: CGRect {
        return CGRect(x: minX, y: minY, width: width, height: 0)
    }
    
    var zeroHeightFullWidthBottomPosition: CGRect {
        return CGRect(x: minX, y: maxY, width: width, height: 0)
    }
    
    var zeroWidthFullHeightLeftPosition: CGRect {
        return CGRect(x: minX, y: minY, width: 0, height: height)
    }
    
    var zeroWidthFullHeightRightPosition: CGRect {
        return CGRect(x: maxX, y: minY, width: 0, height: height)
    }
}
