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
    let id: UUID
    
    enum State {
        case selected
        case deselected
    }
    
    init(state: State) {
        self.state = state
        id = UUID.init()
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeConstraints()
    }
    
    func position() -> AbsolutePosition {
        return absolutePosition
    }
    
    func remove() {
        removeFromSuperview()
    }
    
    func toogleSelection() {
        state = state == .selected ? .deselected : .selected
    }
    
    private func makeConstraints() {
        self.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
    }
    
    private var state: State {
        didSet {
            self.delegate?.canvasCell(self, switchedTo: state)
        }
    }
    
    private var absolutePosition: AbsolutePosition
    private let imageView = UIImageView()
}

extension UIView {
    func flash(duration: TimeInterval) {
        let highLightAnimation = {
            self.layer.borderWidth = 5
            self.layer.borderColor = UIColor.blue.cgColor
            
        }
        
        let unhighlightAnimation = { (flag: Bool) -> Void in
            UIView.animate(withDuration: duration) {
                self.layer.borderWidth = 1
            }
        }
        
        UIView.animate(withDuration: duration, animations: highLightAnimation) { completed in unhighlightAnimation(completed) }
    }
}
