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
        
        let collageCell = CollageCell(color: .blue, image: nil, relativePosition: RelativePosition(x: 0, y: 0, width: 1, height: 1), gripPositions: [])
        
        var collage = Collage(cells: [collageCell])
        
        collage.split(cell: collageCell, by: .vertical)
        collage.split(cell: collage.cells.first!, by: .horizontal)
        collage.split(cell: collage.cells.first!, by: .horizontal)
        collage.split(cell: collage.cells.first!, by: .vertical)
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = CollageSceneViewController(collage: collage)
        window?.makeKeyAndVisible()
        
        return true
    }

}

