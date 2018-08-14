//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

protocol TemplateBarCollectionViewControllerDelegate: AnyObject {
    func templateBarCollectionViewController(_ controller: TemplateBarCollectionViewController, selected collage: Collage)
}

class TemplateBarCollectionViewController: UICollectionViewController {
    
    weak var delegate: TemplateBarCollectionViewControllerDelegate?
    
    init(collageTemplates: [Collage]) {
        self.templates = collageTemplates
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(TemplateBarCollectionViewCell.self, forCellWithReuseIdentifier: TemplateBarCollectionViewCell.identifier)
        collectionView?.backgroundColor = .white
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        layout.minimumInteritemSpacing = 50
        layout.scrollDirection = .horizontal
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templates.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TemplateBarCollectionViewCell.identifier, for: indexPath)
        
        guard let templateBarCell = cell as? TemplateBarCollectionViewCell else {
            return cell
        }
        
        templateBarCell.collage = templates[indexPath.row]
        
        return templateBarCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collage = templates[indexPath.row]
        
        delegate?.templateBarCollectionViewController(self, selected: collage)
    }
    
    private var templates: [Collage]
}

extension TemplateBarCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minValue = min(collectionView.frame.width, collectionView.frame.height) / 2
        
        return CGSize(width: minValue / 2, height: minValue / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let minValue = min(collectionView.frame.width, collectionView.frame.height)
        
        return UIEdgeInsets(top: minValue / 4, left: 40, bottom: minValue / 4, right: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
}
