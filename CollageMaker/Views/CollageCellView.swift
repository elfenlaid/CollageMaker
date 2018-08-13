//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class CollageCellView: UIView {
    
    var state: State = .normal
    
    enum State {
        case selected
        case normal
    }
    
    init(collageCell: CollageCell) {
        self.collageCell = collageCell
        super.init(frame: .zero)
        
        addSubview(imageView)
        addGestureRecognizer(tapGestureRecognizer)
        
        imageView.frame = bounds
        backgroundColor = collageCell.color
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func set(image: UIImage) {
        imageView.image = image
    }
    
    @objc private func tapped(recognizer: UITapGestureRecognizer) {
        state = .selected
    }
    
    private let imageView = UIImageView()
    private (set) var collageCell: CollageCell
    private let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(recognizer:)))
}
