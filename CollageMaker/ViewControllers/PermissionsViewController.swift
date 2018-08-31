//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

class PermissionsViewController: UIViewController {
    
    enum State {
        case firstLaunch
        case denied
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(allowButton)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        gradientLayer.axis(.horizontal)
        gradientLayer.colors = [UIColor.collagePurple.cgColor, UIColor.collagePink.cgColor]
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradientLayer.frame = allowButton.bounds
        gradientLayer.cornerRadius = allowButton.bounds.height / 2
    }
    
    private func makeConstraints() {
        let offset = view.bounds.width / 7
        
        allowButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(offset)
            make.bottom.equalToSuperview().offset(-offset)
            make.height.equalTo(offset * 0.75)
            make.width.equalTo(offset * 2)
        }
    }
    
    private lazy var allowButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.layer.addSublayer(gradientLayer)
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowRadius = 5
        button.layer.shadowColor = UIColor.collagePurple.cgColor
        button.layer.shadowOpacity = 0.3
        button.titleLabel?.font = R.font.sfProDisplayHeavy(size: 19)
        button.setTitle("Allow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private let gradientLayer = CAGradientLayer()
}


extension CAGradientLayer {
    enum Axis {
        case horizontal
        case vertical
    }
    
    func axis(_ axis: Axis) {
        if axis == .horizontal {
            self.startPoint = CGPoint(x: 0, y: 0.5)
            self.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            self.startPoint = CGPoint(x: 0.5, y: 0)
            self.endPoint = CGPoint(x: 0.5, y: 1)
        }
    }
}
