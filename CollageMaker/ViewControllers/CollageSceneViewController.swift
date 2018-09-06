//
//Copyright © 2018 Dimasno1. All rights reserved. Product:  CollageMaker
//

import UIKit
import SnapKit
import AVKit

class CollageSceneViewController: UIViewController {
    
    init(collage: Collage = Collage()) {
        super.init(nibName: nil, bundle: nil)
        collageViewController.collage = collage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(resetButton)
        view.addSubview(shareButton)
        view.addSubview(collageViewContainer)
        view.addSubview(bannerView)
        view.addSubview(toolsBar)
        
        let navBarHeight = UIScreen.main.bounds.height / 10
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.collageCamera(action: #selector(tryToTakePhoto), target: self)
        navigationItem.title = "Edit"
        navigationController?.navigationBar.frame.size.height = navBarHeight
        
        makeConstraints()
        
        let cellOne = CollageCell(color: .collagePink, image: nil, relativeFrame: RelativeFrame(x: 0, y: 0, width: 0.5, height: 1))
        let cellTwo = CollageCell(color: .gray, image: nil, relativeFrame: RelativeFrame(x: 0.5, y: 0, width: 0.5, height: 1))
        let someCell = CollageCell(color: .darkGray, image: nil, relativeFrame: RelativeFrame(x: 0.5, y: 0, width: 0.5, height: 0.5))
        let someAnotherCell = CollageCell(color: .lightGray, image: nil, relativeFrame: RelativeFrame(x: 0.5, y: 0.5, width: 0.5, height: 0.5))
        let oneMoreCollage = Collage(cells: [cellOne, cellTwo])
        let collage = Collage(cells: [cellOne, someCell, someAnotherCell])
        
        let templateBar = TemplateBarCollectionViewController(templates: [oneMoreCollage, collage, oneMoreCollage,collage, oneMoreCollage, collage])
        
        templateBar.delegate = self
        toolsBar.delegate = self
        
        addChild(collageViewController, to: collageViewContainer)
        addChild(templateBar, to: bannerView)
    }
    
    private func makeConstraints() {
        collageViewContainer.snp.makeConstraints { make in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }

            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(collageViewContainer.snp.width)
        }
        
        toolsBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(collageViewContainer).dividedBy(6)
        }
        
        bannerView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(toolsBar.snp.top)
            make.top.equalTo(collageViewContainer.snp.bottom)
        }
    }
    
    @objc private func resetCollage() {
        collageViewController.resetCollage()
    }
    
    @objc private func shareCollage() {
        
    }
    
    func pickImage(camera: Bool = false) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = camera && UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func tryToTakePhoto() {
        handle(AVCaptureDevice.authorizationStatus(for: .video))
    }
    
    private func handle(_ avAuthorizationStatus: AVAuthorizationStatus) {
        switch avAuthorizationStatus {
        case .authorized:
            DispatchQueue.main.async { [weak self] in
                self?.pickImage(camera: true)
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.pickImage(camera: true)
                    }
                }
            }
            
        case .denied:
            let alertViewController = UIAlertController(title: "Sorry", message: "To use camera you should grant access to it", preferredStyle: .alert)
            let action = UIAlertAction(title: "Allow", style: .default) { _ in
                UIApplication.shared.openSettings() }
            let secaction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alertViewController.addAction(action)
            alertViewController.addAction(secaction)
            
            DispatchQueue.main.async { [weak self] in
                self?.present(alertViewController, animated: true, completion: nil)
            }
            
        case .restricted:
            let alertViewController = UIAlertController(title: "Sorry", message: "You're not allowed to change camera acces. Parental controls or institutional configuration profiles restricted your ability to grant camera access.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
            
            alertViewController.addAction(action)
            
            DispatchQueue.main.async { [weak self] in
                self?.present(alertViewController, animated: true, completion: nil)
            }
        }
    }
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(resetCollage), for: .touchUpInside)
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(shareCollage), for: .touchUpInside)
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    private let bannerView = UIView()
    private let toolsBar = CollageToolbar.standart
    private let collageViewContainer: UIView = {
        let view = UIView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private var collageViewController = CollageViewController()
}

extension CollageSceneViewController: TemplateBarCollectionViewControllerDelegate {
    func templateBarCollectionViewController(_ controller: TemplateBarCollectionViewController, didSelect collage: Collage) {
        collageViewController.collage = collage
    }
}

extension UIViewController {
    
    func addChild(_ controller: UIViewController, to container: UIView) {
        self.addChildViewController(controller)
        controller.view.frame = container.bounds
        container.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    func removeFromParent() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
        didMove(toParentViewController: nil)
    }
}

extension CollageSceneViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension CollageSceneViewController: CollageToolbarDelegate {
    func collageToolbar(_ collageToolbar: CollageToolbar, itemTapped: CollageBarItem) {
        switch itemTapped.title {
        case "HORIZONTAL": collageViewController.splitSelectedCell(by: .horizontal)
        case "VERTICAL": collageViewController.splitSelectedCell(by: .vertical)
        case "ADD IMG": pickImage()
        case "DELETE": collageViewController.deleteSelectedCell()
        default: break
        }
    }
}

extension CollageSceneViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        
        collageViewController.addImageToSelectedCell(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

