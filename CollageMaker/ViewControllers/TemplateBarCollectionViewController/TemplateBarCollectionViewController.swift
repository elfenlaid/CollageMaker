//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class TemplateBarCollectionViewController: UICollectionViewController {
    
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
    
    private var templates: [Collage]
}

extension TemplateBarCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
    }
}
