//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit
import Photos

protocol PermissionsViewControllerDelegate: AnyObject {
    func permissionViewControllerDidReceivePermission(_ controller: PermissionsViewController)
}

class PermissionsViewController: UIViewController {

    weak var delegate: PermissionsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(allowButton)
        view.addSubview(subtitleLabel)
        view.addSubview(bottomStackView)

        makeConstraints()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func findLastWordRange(in string: String) -> NSRange? {
        let words = string.split(separator: " ")
        
        guard let lastWord = words.last, let range = string.range(of: lastWord) else {
            return nil
        }
        
        return NSRange(location: range.lowerBound.encodedOffset, length: range.upperBound.encodedOffset - range.lowerBound.encodedOffset)
    }
    
    private func makeConstraints() {
        let sideOffset = UIScreen.main.bounds.width * 0.15
        let topOffset = UIScreen.main.bounds.height * 0.26
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topOffset)
            make.left.equalToSuperview().offset(sideOffset)
            make.right.equalToSuperview().offset(-sideOffset)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(UIScreen.main.bounds.height * 0.02)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
        }
        
        allowButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.25)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(topOffset)
            make.bottom.equalToSuperview().offset(-sideOffset)
        }
    }
    
    @objc private func showCollageScene() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async { self?.handle(status) }
        }
    }
    
    private func handle(_ authorizationStatus: PHAuthorizationStatus) {
        if case .authorized = authorizationStatus {
            delegate?.permissionViewControllerDidReceivePermission(self)
            return
        }

        guard let alertController = Alerts.alert(for: authorizationStatus) else {
            assert(false, "can't handle authorization status \(authorizationStatus)")
        }

        present(alertController, animated: true, completion: nil)
    }
    
    private lazy var allowButton: UIButton = {
        let button = GradientButton(type: .system)

        button.setTitle("Allow", for: .normal)
        button.addTarget(self, action: #selector(showCollageScene), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.font = R.font.sfProDisplayHeavy(size: 46)
        label.textAlignment = .left
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.8
        
        
        let attributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                          NSAttributedStringKey.kern: CGFloat(-1.85),
                          ] as [NSAttributedStringKey : Any]
        
        let attributedString = NSMutableAttributedString(string: "Start Your Masterpiece", attributes: attributes)
        
        if let range = findLastWordRange(in: attributedString.string) {
            attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.brightLavender], range: range)
        }
        
        label.attributedText = attributedString
        label.sizeToFit()
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        
        let attributes = [ NSAttributedStringKey.kern: CGFloat(-1.0)]
        let attributedString = NSMutableAttributedString(string: "The best photos are already here, make them speak", attributes: attributes)
        
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = R.font.sfProTextLight(size: 15)
        label.sizeToFit()
        
        return label
    }()
    
    private let accessLabel: UILabel = {
        let label = UILabel()
        
        let attributes = [ NSAttributedStringKey.kern: CGFloat(-1.0)]
        let attributedString = NSMutableAttributedString(string: "Access to Photos", attributes: attributes)
        
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = R.font.sfProDisplayHeavy(size: 25)
        label.sizeToFit()
        
        return label
    }()
    
    private let accessMessageLabel: UILabel = {
        let label = UILabel()
        
        let attributes = [ NSAttributedStringKey.kern: CGFloat(-1.0)]
        let attributedString = NSMutableAttributedString(string: "Collagist needs access to photos to turn them into masterpieces.", attributes: attributes)
        
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = R.font.sfProTextLight(size: 15)
        label.attributedText = attributedString
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [accessLabel, accessMessageLabel, allowButton])
        
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        stackView.spacing = 5
        
        return stackView
    }()
}

private extension Alerts {
    static func alert(for status: PHAuthorizationStatus) -> UIAlertController? {
        switch status {
        case .denied: return Alerts.photoAccessDenied()
        case .restricted: return Alerts.photoAccessRestricted()
        case .authorized, .notDetermined: return nil
        }
    }
}
