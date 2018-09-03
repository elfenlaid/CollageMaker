//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

class CollageBarItem: UIView {
    
    let title: String
    let normalStateImage: UIImage
    let tappedStateImage: UIImage
    
    init(title: String, image: UIImage, tappedImage: UIImage? = nil) {
        self.title = title
        self.normalStateImage = image
        
        if let tappedImage = tappedImage {
            self.tappedStateImage = tappedImage
        } else {
            self.tappedStateImage = image
        }
        
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        addSubview(imageView)
        
        setup()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        UIView.animate(withDuration: 0.2,
                       animations: { self.imageView.alpha = 0.2})
        { _ in UIView.animate(withDuration: 0.5, animations: { self.imageView.alpha = 1}) }
    }
    
    private func setup() {
        imageView.image = normalStateImage
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.font = titleLabel.font.withSize(10.0)
        titleLabel.text = title
        titleLabel.textAlignment = .center
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.3)
            make.height.equalToSuperview().dividedBy(4)
        }
        
        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }
    }
    
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
}

extension CollageBarItem {
    static var horizontal: CollageBarItem {
        return CollageBarItem(title: "HORIZONTAL", image: R.image.horizontal() ?? .none)
    }
    
    static var vertical: CollageBarItem {
        return CollageBarItem(title: "VERTICAL", image: R.image.vertical() ?? .none)
    }
    
    static var addImage: CollageBarItem {
        return CollageBarItem(title: "ADD IMG", image: R.image.addimg() ?? .none)
    }
    
    static var delete: CollageBarItem {
        return CollageBarItem(title: "DELETE", image: R.image.addimg() ?? .none)
    }
}

extension UIImage {
    static var none: UIImage {
        return UIImage()
    }
}
