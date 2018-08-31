//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

class CollageCellView: UIView {
    
    init(collageCell: CollageCell, frame: CGRect) {
        self.collageCell = collageCell
        super.init(frame: frame)
        
        if let image = collageCell.image {
            setup()
            
            imageView = UIImageView(image: image)
            
            scrollView.contentSize = image.size
            scrollView.addSubview(imageView)
            addSubview(scrollView)
        } else {
            backgroundColor = collageCell.color
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.setNeedsDisplay(self.frame)
        scrollView.center = convert(center, from: superview ?? self)
        scrollView.bounds.size = self.bounds.size
        
        setup()
    }
    
    func changeFrame(to: CGRect) {
        self.frame = to
    }
    
    private func setup() {
        guard let image = collageCell.image else {
            return
        }

        let widthScale = scrollView.frame.width / image.size.width
        let heightScale = scrollView.frame.height / image.size.height
        let minScale = max(widthScale, heightScale)
        
        scrollView.setup(maxZoomScale: minScale * 2, minZoomScale: minScale, delegate: self)
        scrollView.setZoomScale(minScale, animated: false)
    }

    private lazy var imageView = UIImageView()
    private lazy var scrollView = UIScrollView()
    private(set) var collageCell: CollageCell
}

extension CollageCellView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension UIScrollView {
    func setup(maxZoomScale: CGFloat = 1, minZoomScale: CGFloat = 1, isScrollEnabled: Bool = true, delegate: UIScrollViewDelegate) {
        maximumZoomScale = maxZoomScale
        minimumZoomScale = minZoomScale
        contentInsetAdjustmentBehavior = .never
        bouncesZoom = false
        bounces = false
        
        self.delegate = delegate
        self.isScrollEnabled = isScrollEnabled
    }
}
