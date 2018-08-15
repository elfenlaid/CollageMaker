//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

class CollageCellView: UIView {
    
    init(collageCell: CollageCell) {
        self.collageCell = collageCell
        super.init(frame: .zero)
        
        backgroundColor = collageCell.color
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3
    
        addSubview(imageView)
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func set(image: UIImage) {
        imageView.image = image
    }
  
    private func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
    }
    
    private let imageView = UIImageView()
    private (set) var collageCell: CollageCell
}
