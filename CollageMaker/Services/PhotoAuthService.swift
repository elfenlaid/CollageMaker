//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import Foundation
import Photos

protocol PhotoAuthStatusProtocol {
    var status: PhotoAuthService.Status { get }
}

final class MockPhotoAuthSerivice {
    var status: PhotoAuthService.Status = .authorized
}

final class PhotoAuthService {
    enum Status {
        case authorized
        case denied
        case nonDetermined
    }

    var isAuthorized: Bool {
        return status.isAuthorized
    }

    var status: Status {
        return Status(status: PHPhotoLibrary.authorizationStatus())
    }

    func requestAuthorization(callback: @escaping (Status) -> Void){
        PHPhotoLibrary.requestAuthorization { photoStatus in
            let status = Status(status: photoStatus)
            callback(status)
        }
    }
}

extension PhotoAuthService.Status {
    init(status: PHAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .nonDetermined
        case .restricted, .denied: self = .denied
        case .authorized: self = .authorized
        }
    }

    var isAuthorized: Bool {
        if case .authorized = self {
            return true
        }

        return false
    }
}
