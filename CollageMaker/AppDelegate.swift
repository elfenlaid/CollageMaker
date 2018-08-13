//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import Crashlytics
import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        Fabric.with([Crashlytics.self()])
        
        let collageCell = CollageCell(grips: [], color: .red, image: nil, relativePosition: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        var collage = Collage(cells: [collageCell])
        
        collage.split(cell: collageCell, by: .vertical)
        collage.split(cell: collage.allCells().first!, by: .horizontal)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = CollageSceneViewController(collage: collage)
        window?.makeKeyAndVisible()
        
        return true
    }

}

