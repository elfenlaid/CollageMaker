//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import Foundation
import UIKit

final class Navigator {
    init(authSerivce: PhotoAuthService = PhotoAuthService()) {
        self.authService = authSerivce
    }

    lazy var rootViewController: UINavigationController = {
        if authService.isAuthorized {
            return CollageNavigationController(rootViewController: CollageSceneViewController())
        } else {
            let controller = PermissionsViewController()
            controller.delegate = self
            return CollageNavigationController(rootViewController: controller)
        }
    }()

    private let authService: PhotoAuthService
}

extension Navigator: PermissionsViewControllerDelegate {
    func permissionViewControllerDidReceivePermission(_ controller: PermissionsViewController) {
        let controller = CollageSceneViewController()
        rootViewController.pushViewController(controller, animated: true)
    }
}
