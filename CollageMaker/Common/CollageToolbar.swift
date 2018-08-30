//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

protocol CollageToolbarDelegate: AnyObject {
    func collageToolbar(_ collageToolbar: CollageToolbar, itemTapped: CollageBarItem)
}

class CollageToolbar: UIView {
    
    weak var delegate: CollageToolbarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
        
        addSubview(buttonsStackView)
        addGestureRecognizer(tapGestureRecognizer)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private func setup() {
        let horizontal = CollageBarItem.horizontal
        let vertical =  CollageBarItem.vertical
        let addimg = CollageBarItem.addImage
        
        buttonsStackView.addArrangedSubview(horizontal)
        buttonsStackView.addArrangedSubview(vertical)
        buttonsStackView.addArrangedSubview(addimg)
        
        buttonsStackView.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
    }
    
    @objc private func itemTapped(_ recoginzer: UITapGestureRecognizer) {
        let point = recoginzer.location(in: self)
        
        guard let item = itemForPoint(point) else {
            return
        }
        
        item.animate()
        
        delegate?.collageToolbar(self, itemTapped: item)
    }
    
    private func itemForPoint(_ point: CGPoint) -> CollageBarItem? {
        return buttonsStackView.arrangedSubviews.first(where: { $0.frame.contains(point) }) as? CollageBarItem
    }
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        return stackView
    }()
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer()
}
