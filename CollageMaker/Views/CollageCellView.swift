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
    
        addSubview(imageView)
        makeConstraints()
        
        imageView.image = collageCell.image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func changeFrame(to: CGRect) {
        self.frame = to
    }

    private func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
    }
    
    private let imageView = UIImageView()
    private(set) var collageCell: CollageCell
}
