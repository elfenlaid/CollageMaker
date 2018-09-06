//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import Crashlytics
import Fabric
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        //        Fabric.with([Crashlytics.self()])
        
        let collage = Collage()
        let navigationController: CollageNavigationController
        
        if checkAccesToPhotoLibrary() {
            navigationController = CollageNavigationController(rootViewController: CollageSceneViewController(collage: collage))
        } else {
            navigationController = CollageNavigationController(rootViewController: PermissionsViewController())
        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func checkAccesToPhotoLibrary() -> Bool {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined, .restricted, .denied: return false
        case .authorized: return true
        }
    }
}

