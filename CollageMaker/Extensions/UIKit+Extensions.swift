//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import Foundation
import UIKit

extension CAGradientLayer {
    enum Axis {
        case horizontal
        case vertical
    }

    func setAxis(_ axis: Axis) {
        if axis == .horizontal {
            self.startPoint = CGPoint(x: 0, y: 0.5)
            self.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            self.startPoint = CGPoint(x: 0.5, y: 0)
            self.endPoint = CGPoint(x: 0.5, y: 1)
        }
    }
}


class Alerts {
    static func photoAccessDenied() -> UIAlertController {
        let alertViewController = UIAlertController(title: "Sorry", message: "To use this app you should grant access to photo library. Would you like to change your opinion and grant photo library access to CollagistApp?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Sure", style: .default) { _ in
            UIApplication.shared.openSettings()
        }
        let secaction = UIAlertAction(title: "Nope", style: .destructive, handler: nil)

        alertViewController.addAction(action)
        alertViewController.addAction(secaction)

        return alertViewController
    }

    static func photoAccessRestricted() -> UIAlertController {
        let alertViewController = UIAlertController(title: "Sorry", message: "You're not allowed to change photo library acces. Parental controls or institutional configuration profiles restricted your ability to grant photo library access. ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .default, handler: nil)

        alertViewController.addAction(action)
        return alertViewController
    }
}


extension UIApplication {
    func openSettings() {
        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }

        self.open(settingsURL, completionHandler: nil)
    }
}

