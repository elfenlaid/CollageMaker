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
    
    init(color: UIColor, image: UIImage? = nil, relativeFrame: RelativeFrame) {
        self.color = color
        self.image = image
        self.relativeFrame = isAllowed(position: relativeFrame) ? relativeFrame : RelativeFrame.zero
        
        calculateGripPositions()
    }
    
    func belongsToParallelLine(on axis: Axis, with point: CGPoint) -> Bool {
        if axis == .horizontal {
            return abs(point.y - relativeFrame.minY) < .allowableAccuracy || abs(point.y - relativeFrame.maxY) < .allowableAccuracy
        } else if axis == .vertical {
            return abs(point.x - relativeFrame.minX) < .allowableAccuracy || abs(point.x - relativeFrame.maxX) < .allowableAccuracy
        } else {
            return false
        }
    }
    
    mutating func changeRelativeFrame(to: RelativeFrame) {
        guard isAllowed(position: to) else {
            return
        }
        
        relativeFrame = to
    }
    
    mutating func calculateGripPositions(){
        gripPositions.removeAll()
        
        guard relativeFrame.isFullsized == false else {
            return
        }
        
        if relativeFrame.minX > .allowableAccuracy { gripPositions.insert(.left) }
        if relativeFrame.minY > .allowableAccuracy { gripPositions.insert(.top) }
        if abs(relativeFrame.maxX - 1) > .allowableAccuracy { gripPositions.insert(.right) }
        if abs(relativeFrame.maxY - 1) > .allowableAccuracy { gripPositions.insert(.bottom) }
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
    
    func isAllowed(position: RelativeFrame) -> Bool {
        return min(position.width, position.height) > 0.2  && max(position.width, position.height) <= 1 ? true : false
    }
    
    private(set) var relativeFrame = RelativeFrame.zero
    private(set) var gripPositions: Set<GripPosition> = []
}

extension CollageCell {
    static var null: CollageCell {
        return CollageCell(color: .black, relativeFrame: .zero)
    }
}

enum GripPosition {
    case top
    case bottom
    case left
    case right
    
    var axis: Axis {
        switch self {
        case .left, .right: return .vertical
        case .top, .bottom: return .horizontal
        }
    }
    
    func centerPoint(in cell: CollageCell) -> CGPoint {
        switch self {
        case .left: return CGPoint(x: cell.relativeFrame.minX, y: cell.relativeFrame.midY)
        case .right: return CGPoint(x: cell.relativeFrame.maxX, y: cell.relativeFrame.midY)
        case .top: return CGPoint(x: cell.relativeFrame.midX, y: cell.relativeFrame.minY)
        case .bottom: return CGPoint(x: cell.relativeFrame.midX, y: cell.relativeFrame.maxY)
        }
    }
    
    func sideChangeValue(for position: RelativeFrame) -> CGFloat {
        switch self {
        case .left:
            return position.width
        case .right:
            return -position.width
        case .top:
            return position.height
        case .bottom:
            return -position.height
        }
    }
}
