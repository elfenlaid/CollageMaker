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
    
    convenience init(barItems: [CollageBarItem]) {
        self.init(frame: .zero)
        
        barItems.forEach { addCollageBarItem($0) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
        
        addSubview(buttonsStackView)
        addGestureRecognizer(tapGestureRecognizer)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func addCollageBarItem(_ item: CollageBarItem) {
        buttonsStackView.addArrangedSubview(item)
    }
    
    private func makeConstraints() {
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

extension CollageToolbar {
    static var standart: CollageToolbar {
        let horizontal = CollageBarItem.horizontal
        let vertical =  CollageBarItem.vertical
        let addimg = CollageBarItem.addImage
        let delete = CollageBarItem.delete
        
        return CollageToolbar(barItems: [horizontal, vertical, addimg, delete])
    }
}
