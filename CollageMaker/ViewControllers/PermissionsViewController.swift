//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit
import Photos

class PermissionsViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(titleLabel)
        view.addSubview(allowButton)
        view.addSubview(subtitleLabel)
        view.addSubview(bottomStackView)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradientLayer.frame = allowButton.bounds
        gradientLayer.cornerRadius = allowButton.bounds.height / 2
    }
    
    private func findLastWordRange(in string: String) -> NSRange? {
        let words = string.split(separator: " ")
        
        guard let lastWord = words.last, let range = string.range(of: lastWord) else {
            return nil
        }
        
        return NSRange(location: range.lowerBound.encodedOffset, length: range.upperBound.encodedOffset - range.lowerBound.encodedOffset)
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        gradientLayer.axis(.horizontal)
        gradientLayer.colors = [UIColor.brightLavender.cgColor, UIColor.collagePink.cgColor]
        
        navigationController?.navigationBar.frame.size.height = UIScreen.main.bounds.height / 10
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
        PHPhotoLibrary.requestAuthorization { [weak self] in self?.handle($0) }
    }
    
    private func handle(_ authorizationStatus: PHAuthorizationStatus) {
        switch authorizationStatus {
        case .authorized:
            DispatchQueue.main.async { [weak self] in
                let controller = CollageSceneViewController()
                
                if let navCon = self?.navigationController {
                    navCon.pushViewController(controller, animated: true)
                } else {
                    self?.present(controller, animated: true, completion: nil)
                }
            }
            
        case .denied:
            let alertViewController = UIAlertController(title: "Sorry", message: "To use this app you should grant access to photo library. Would you like to change your opinion and grant photo library access to CollagistApp?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Sure", style: .default) { _ in
                UIApplication.shared.openSettings() }
            let secaction = UIAlertAction(title: "Nope", style: .destructive, handler: nil)
            
            alertViewController.addAction(action)
            alertViewController.addAction(secaction)
            
            DispatchQueue.main.async { [weak self] in
                self?.present(alertViewController, animated: true, completion: nil)
            }
            
        case .restricted:
            let alertViewController = UIAlertController(title: "Sorry", message: "You're not allowed to change photo library acces. Parental controls or institutional configuration profiles restricted your ability to grant photo library access. ", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
            
            alertViewController.addAction(action)
            
            DispatchQueue.main.async { [weak self] in
                self?.present(alertViewController, animated: true, completion: nil)
            }
            
        default: break
        }
    }
    
    private lazy var allowButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.layer.addSublayer(gradientLayer)
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowRadius = 5
        button.layer.shadowColor = UIColor.brightLavender.cgColor
        button.layer.shadowOpacity = 0.3
        button.titleLabel?.font = R.font.sfProDisplayHeavy(size: 19)
        button.setTitle("Allow", for: .normal)
        button.setTitleColor(.white, for: .normal)
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
    
    private let gradientLayer = CAGradientLayer()
}


extension CAGradientLayer {
    enum Axis {
        case horizontal
        case vertical
    }
    
    func axis(_ axis: Axis) {
        if axis == .horizontal {
            self.startPoint = CGPoint(x: 0, y: 0.5)
            self.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            self.startPoint = CGPoint(x: 0.5, y: 0)
            self.endPoint = CGPoint(x: 0.5, y: 1)
        }
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
