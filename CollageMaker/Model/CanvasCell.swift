//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

protocol CanvasCellDelegate: AnyObject {
    func canvasCell(_ cell: CanvasCell, switchedTo state: CanvasCell.State)
}

class CanvasCell: UIView {
    
    weak var delegate: CanvasCellDelegate?
    
    let cellID = UUID.init()
    
    enum Axis: Int {
        case horizontal
        case vertical
    }
    
    enum State {
        case selected
        case deselected
    }
    
    private var state: State {
        get {
            return attributes.state
        } set {
            attributes.state = newValue
            self.delegate?.canvasCell(self, switchedTo: newValue)
        }
    }
    
    var isInitial: Bool {
        return attributes.isInitial
    }
    
    var imageURL: String? {
        return attributes.imageURL
    }
    
    var parentCellID: UUID? {
        return attributes.parentCellID
    }
    
    var childCellsIDs: [UUID]? {
        return attributes.childCellsIDs
    }
    
    var childCellsLayoutAxis: Axis? {
        return attributes.childCellsLayoutAxis
    }
    
    init(attributes: CellAttributes) {
        self.attributes = attributes
        super.init(frame: CGRect.zero)
        
        addSubview(imageView)
        addGestureRecognizer(tapGestureRecognizer)
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func updateAttributes(with: CellAttributes) {
        attributes = with
        CollageCanvas.shared.updateValue(cellAttributes: (cellID, attributes))
    }
    
    private func updateView() {
        if childCellsIDs?.count != nil {
            childCellsIDs?.forEach {
                guard let attributes = CollageCanvas.shared.cellAttributes(for: $0) else {
                    return
                }
                
                let cell = CanvasCell(attributes: attributes)
                cellStackView.addArrangedSubview(cell)
            }
            imageView.removeFromSuperview()
            addSubview(cellStackView)
        }
    }
    
    @objc private func cellTapped() {
        flash(duration: 0.75)
        state = .selected
    }
    
    private lazy var cellStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let imageView = UIImageView()
    private var attributes: CellAttributes
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
}

extension UIView {
    func flash(duration: TimeInterval) {
        let highLightAnimation = {
            self.backgroundColor = .blue
        }
        
        let unhighlightAnimation = { (flag: Bool) -> Void in
            UIView.animate(withDuration: duration / 2) {
                self.backgroundColor = .clear
            }
        }
        
        UIView.animate(withDuration: duration / 2, animations: highLightAnimation) { completed in unhighlightAnimation(completed) }
    }
}

extension CanvasCell: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = CanvasCell(attributes: attributes)
        return copy
    }
}
