//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

class TemplateBarCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var collage: Collage? {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        collage = nil
        imageView.image = nil
    }
    
    func update() {
        guard let collage = collage else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            let image = CollageRenderer.renderImage(from: collage, with: CGSize(width: 75, height: 75))
            
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
            
        }
        
        
        
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
    }
    
    private let imageView = UIImageView()
}
