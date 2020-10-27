//
//  TemplateEditingViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-07.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class TemplateEditingViewController: UIViewController {
    static let identifier = "TemplateEditingViewController"
    
    @IBOutlet private weak var img: UIImageView!
    @IBOutlet private weak var overlayView: UIView!
    
    class func newInstance(img: UIImage, delegate: MediaManagementDelegate) -> TemplateEditingViewController {
        let instance = templateStoryboard.instantiateViewController(withIdentifier: self.identifier) as! TemplateEditingViewController
        instance.image = img
        instance.delegate = delegate
        return instance
    }
    
    private var contentViews: [DragScaleAndRotateView] {
        return self.overlayView.subviews.compactMap({ $0 as? DragScaleAndRotateView })
    }

    private var mediaManager: MediaManager {
        return .sharedInstance
    }
    private var shouldSetTitle: Bool = true
    private var image: UIImage!
    private var delegate: MediaManagementDelegate? = nil
    
    private lazy var productPickerVC: ProductTagPickerViewController = {
        return .newInstance(delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = .init(title: "Create", style: .plain, target: self, action: #selector(self.createButtonPressed))
        self.img.image = self.image
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.contentViews.isEmpty, self.shouldSetTitle {
            let view = DragScaleAndRotateView.init(frame: .zero, currentScale: 1, type: .text(.init(text: "VS", isTitle: true)), delegate: nil)
            self.overlayView.addSubview(view)

            view.changeTextAndLoadImg(newText: "VS")
            view.center = .init(x: self.overlayView.bounds.midX, y: self.overlayView.bounds.maxY - 40)
            self.shouldSetTitle = false
        }
    }

    @IBAction func tagProductButtonPressed(_ sender: Any) {
        self.present(self.productPickerVC, animated: true)
    }
    
    @objc func createButtonPressed() {
        guard let url = self.mediaManager.saveImage(fileName: UUID().uuidString, image: self.image) else { return }
        self.delegate?.didCreateMedia(media: .init(url: url, preview: self.image, mediaType: .image))
        self.navigationController?.dismiss(animated: true)
    }
}

extension TemplateEditingViewController: ProductTagPickerDelegate {
    func didSelect(product: Product) {
        let view = DragScaleAndRotateView(frame: CGRect(origin: self.overlayView.center, size: .zero), currentScale: 1, type: .productTag, delegate: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let productView: ProductTagView = .fromNib()
        productView.configureView(product: product)
        view.addSubview(productView)
        productView.snp.makeConstraints({ $0.edges.equalToSuperview() } )
        
        self.overlayView.addSubview(view)
        view.center = self.overlayView.center
    }
}
