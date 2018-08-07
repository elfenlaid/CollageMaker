//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit

class ToolsBar: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.items = [UITabBarItem.init(tabBarSystemItem: .contacts, tag: 0),
                      UITabBarItem.init(tabBarSystemItem: .downloads, tag: 1),
                      UITabBarItem.init(tabBarSystemItem: .favorites, tag: 2),
                      UITabBarItem.init(tabBarSystemItem: .history, tag: 3)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    
    
}
