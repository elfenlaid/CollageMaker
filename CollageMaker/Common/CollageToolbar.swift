//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

protocol CollageToolbarDelegate: AnyObject {
    
}

class CollageToolbar: UIView {
    
    weak var delegate: CollageToolbarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(buttonsStackView)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private func setup() {
        
        let horizontal = CollageBarItem(title: "HORIZONTAL", image: UIImage(named: "horizontal.png")!)
        let vertical = CollageBarItem(title: "VERTICAL", image: UIImage(named: "vertical.png")!)
        let addimg = CollageBarItem(title: "ADD IMG", image: UIImage(named: "addimg.png")!)
        
        buttonsStackView.addArrangedSubview(horizontal)
        buttonsStackView.addArrangedSubview(vertical)
        buttonsStackView.addArrangedSubview(addimg)
        
        buttonsStackView.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
    }
    
    @objc private func buttonTapped(_ button: CollageBarItem) {
        
    }
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        return stackView
    }()
}
