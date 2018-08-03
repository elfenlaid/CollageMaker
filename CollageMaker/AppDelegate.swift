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
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = CollageSceneViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

