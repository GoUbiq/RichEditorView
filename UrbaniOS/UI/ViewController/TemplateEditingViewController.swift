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
    @IBOutlet private weak var trashView: CircleImageView!

    
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
    
    private lazy var productPickerVC: UINavigationController = {
        let vc = ProductTagPickerSearchResultViewController.newInstance(delegate: self)
        return SearchViewController.newInstance(searchResultVC: vc)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trashView.layer.borderWidth = 1
        self.trashView.layer.borderColor = UIColor.white.cgColor
        self.trashView.isHidden = true
        
        self.navigationItem.rightBarButtonItem = .init(title: "Create", style: .plain, target: self, action: #selector(self.createButtonPressed))
        self.img.image = self.image
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.contentViews.isEmpty, self.shouldSetTitle {
            let textInfo: TextInfo = .init(text: "VS", isTitle: true)
            let view = DragScaleAndRotateView.init(frame: .zero, currentScale: 1, type: .text(textInfo), delegate: self)
            self.overlayView.addSubview(view)

            view.changeTextInfo(newTextInfo: textInfo)
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
    func didSelect(tag: ProductTag) {
        self.productPickerVC.dismiss(animated: true)
        let view = DragScaleAndRotateView(frame: CGRect(origin: self.overlayView.center, size: tag.productTagViewHeight), currentScale: 1, type: .productTag, delegate: self)
        
        let productView: ProductTagView = .fromNib()
        productView.configureView(tag: tag)
        view.addSubview(productView)
        productView.snp.makeConstraints({ $0.edges.equalToSuperview() } )
        
        self.overlayView.addSubview(view)
        view.center = .init(x: self.overlayView.bounds.midX, y: self.overlayView.bounds.midY)
    }
}

extension TemplateEditingViewController: DragScalePositionDelegate {
    func viewDragStarted(view: DragScaleAndRotateView) {
        self.trashView.isHidden = false
        self.contentViews.forEach({ $0.clearSelection() })
    }
    
    func viewPositionChanged(view: DragScaleAndRotateView, touchPoint: CGPoint) {
        if (self.view.convert(self.trashView.frame, to: self.overlayView).contains(touchPoint)) {
            view.isHidden = true
            self.trashView.tintColor = .gray
            self.trashView.backgroundColor = .white
        } else {
            view.isHidden = false
            self.trashView.tintColor = .white
            self.trashView.backgroundColor = .clear
        }
    }
    
    func viewDragEnded(view: DragScaleAndRotateView) {
        if view.isHidden == true {
            view.removeFromSuperview()
        }
        self.trashView.isHidden = true
    }
    
    func viewDidSelect(view: DragScaleAndRotateView) {
        guard case .text(let textInfo) = view.type else { return }
        let vc = TextStickerEditionViewController.newInstance(stickerId: view.id, textInfo: textInfo, delegate: self)
        self.present(vc, animated: true)
    }
}

extension TemplateEditingViewController: TextStickerEditionDelegate {
    func editingDoneWith(stickerId: UUID, newTextInfo: TextInfo) {
        self.contentViews.first(where: { $0.id == stickerId })?.changeTextInfo(newTextInfo: newTextInfo)
    }
}

