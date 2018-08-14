//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit

class CollageSceneViewController: UIViewController {
    
    init(collage: Collage = Collage(cells: [])) {
        collageViewController = CollageViewController(collage: collage)
        collageViewContainer.contentMode = .scaleAspectFit
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .white
        
        view.addSubview(resetButton)
        view.addSubview(shareButton)
        view.addSubview(collageViewContainer)
        view.addSubview(bannerView)
        view.addSubview(toolsBar)
        
        toolsBar.delegate = self

        makeConstraints()
        
        addChild(collageViewController, to: collageViewContainer)
        
        
        
        let cellOne = CollageCell(color: .red, image: nil, relativePosition: RelativePosition(x: 0, y: 0, width: 0.5, height: 1), gripPositions: [])
        let cellTwo = CollageCell(color: .yellow, image: nil, relativePosition: RelativePosition(x: 0.5, y: 0, width: 0.5, height: 1), gripPositions: [])
        let someCell = CollageCell(color: .blue, image: UIImage(named: "wiggles@2x.jpeg")!, relativePosition: RelativePosition(x: 0.5, y: 0, width: 0.5, height: 0.5), gripPositions: [])
        let someAnotherCell = CollageCell(color: .cyan, image: nil, relativePosition: RelativePosition(x: 0.5, y: 0.5, width: 0.5, height: 0.5), gripPositions: [])
        
        let oneMoreCollage = Collage(cells: [cellOne, cellTwo])
        let collage = Collage(cells: [cellOne, someCell, someAnotherCell])
        
        let templateBar = TemplateBarCollectionViewController(collageTemplates: [oneMoreCollage, collage, oneMoreCollage, oneMoreCollage, collage, oneMoreCollage, oneMoreCollage, collage])
        
        addChild(templateBar, to: bannerView)
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
        
        collageViewContainer.snp.makeConstraints { make in
            make.top.equalTo(resetButton.snp.bottom).offset(offset)
            make.left.equalTo(resetButton)
            make.right.equalTo(shareButton)
            make.height.equalTo(collageViewContainer.snp.width)
        }
        
        toolsBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(collageViewContainer).dividedBy(5)
        }
        
        bannerView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(toolsBar.snp.top)
            make.top.equalTo(collageViewContainer.snp.bottom).offset(offset)
        }
    }
 
    @objc private func buttonTapped(_ button: UIButton) {
        switch button {
        case resetButton: break
        case shareButton: break
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
    private let collageViewContainer = UIImageView()
    private var collageViewController: CollageViewController
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
        case 1: break
        default: break
        }
    }
    
}
