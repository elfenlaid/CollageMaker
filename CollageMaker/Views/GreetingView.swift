//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

class GreetingView: UIView {
    
    init() {
        super.init(frame: .zero)
        
        addSubview(labelsStackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelsStackView.frame = bounds
    }
    
    private func findLastWordRange(in string: String) -> NSRange? {
        var word = ""
        
        string.forEach { $0 == " " ? word = "" : word.append($0) }
        
        guard let range = string.range(of: word) else {
            return nil
        }
        
        return NSRange(location: range.lowerBound.encodedOffset, length: range.upperBound.encodedOffset - range.lowerBound.encodedOffset)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.85
        
        let attributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                          NSAttributedStringKey.kern: CGFloat(-2.0)] as [NSAttributedStringKey : Any]
        
        let attributedString = NSMutableAttributedString(string: "Start Your Masterpiece", attributes: attributes)
        
        if let range = findLastWordRange(in: attributedString.string) {
            attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.collagePurple], range: range)
        }
        
        label.numberOfLines = 2
        label.font = R.font.sfProDisplayHeavy(size: 45)
        label.textAlignment = .left
        label.attributedText = attributedString
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "The best photos are already here, make them speak"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = R.font.sfProTextLight(size: 15)
       
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        
        stackView.axis = .vertical
        
        return stackView
    }()
    
}
