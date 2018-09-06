//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import Foundation
import UIKit

class GradientButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.addSublayer(gradientLayer)
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 5
        layer.shadowColor = UIColor.brightLavender.cgColor
        layer.shadowOpacity = 0.3
        titleLabel?.font = R.font.sfProDisplayHeavy(size: 19)
        setTitleColor(.white, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.setAxis(.horizontal)
        layer.colors = [UIColor.brightLavender.cgColor, UIColor.collagePink.cgColor]
        return layer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = bounds.height / 2
    }
}
