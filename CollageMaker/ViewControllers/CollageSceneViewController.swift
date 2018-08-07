//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

class CollageSceneViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .white
        
        view.addSubview(resetButton)
        view.addSubview(shareButton)
        view.addSubview(canvasViewContainer)
        view.addSubview(bannerView)
        view.addSubview(toolsBar)
        
        toolsBar.delegate = self
        
        addChild(collageCanvasViewController, to: canvasViewContainer)

        makeConstraints()
    }
    
    private func makeConstraints() {
        let offset: CGFloat = 20
    
        resetButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offset)
            make.left.equalToSuperview().offset(2 * offset)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(resetButton)
            make.right.equalToSuperview().offset(-2 * offset)
            make.size.equalTo(resetButton)
        }
        
        canvasViewContainer.snp.makeConstraints { make in
            make.top.equalTo(resetButton.snp.bottom).offset(offset)
            make.left.equalTo(resetButton)
            make.right.equalTo(shareButton)
            make.height.equalTo(canvasViewContainer.snp.width)
        }
        
        toolsBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(canvasViewContainer).dividedBy(5)
        }
        
        bannerView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(toolsBar.snp.top)
            make.top.equalTo(canvasViewContainer.snp.bottom).offset(offset)
        }
    }
 
    @objc private func buttonTapped(_ button: UIButton) {
        switch button {
        case resetButton: break
        case shareButton: shareViewController = ShareViewController(with: UIImage(named: "some")!)
        default: break
        }
    }
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    private let bannerView = UIView()
    private let toolsBar = ToolsBar()
    private let canvasViewContainer = UIView()
    private lazy var collageCanvasViewController = CollageCanvasViewController()
    private lazy var shareViewController = ShareViewController(with: UIImage(named: "some")!)
}

extension UIViewController {
    
    func addChild(_ controller: UIViewController, to container: UIView) {
        self.addChildViewController(controller)
        controller.view.frame = container.bounds
        container.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    func removeFromParent() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
        didMove(toParentViewController: nil)
    }
}

extension CollageSceneViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0: break
        case 1: print("YO")
        default: break
        }
        
    }
}
