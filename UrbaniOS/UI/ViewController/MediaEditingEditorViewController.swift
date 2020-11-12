//
//  MediaEditingEditorViewController.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-11-11.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class MediaEditingEditorViewController: UIViewController {
    static let identifier = "MediaEditingEditorViewController"
    
    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet private weak var trashView: CircleImageView!
    
    class func newInstance(img: UIImage, shouldRotate: Bool, delegate: MediaPageControllerDelegate) -> MediaEditingEditorViewController {
        let instance = templateStoryboard.instantiateViewController(withIdentifier: self.identifier) as! MediaEditingEditorViewController
        instance.previewImg = img
        instance.delegate = delegate
        instance.shouldRotate = shouldRotate
        return instance
    }
    
    private var shouldRotate: Bool = false
    private var previewImg: UIImage!
    private var shouldSetTitle: Bool = true
    private var delegate: MediaPageControllerDelegate? = nil
    private var contentViews: [DragScaleAndRotateView] {
        return self.overlayView?.subviews.compactMap({ $0 as? DragScaleAndRotateView }) ?? []
    }
    
    private var productTags: [ProductTag] {
        return self.contentViews.compactMap({ $0.getProductTag() })
    }
    
    private var mediaManager: MediaManager {
        return .sharedInstance
    }
    
    private var editingTxtViewId: UUID? = nil {
        didSet {
            if oldValue == nil, let id = self.editingTxtViewId, case .text(let textInfo) = self.contentViews.first(where: { $0.id == id })?.type {
                let vc = TextStickerEditionViewController.newInstance(stickerId: id, textInfo: textInfo, delegate: self)
                self.present(vc, animated: true)
            }
            
            self.contentViews.forEach({ $0.isHidden = $0.id == self.editingTxtViewId })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trashView.layer.borderWidth = 1
        self.trashView.layer.borderColor = UIColor.white.cgColor
        self.trashView.isHidden = true
        
        self.previewImage.image = self.previewImg
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        if self.contentViews.isEmpty, self.shouldSetTitle {
//            let textInfo: TextInfo = .init(text: "VS", isTitle: true)
//            let view = DragScaleAndRotateView.init(frame: .zero, currentScale: 1, type: .text(textInfo), delegate: self)
//            self.overlayView.addSubview(view)
//
//            view.changeTextInfo(newTextInfo: textInfo)
//            view.center = .init(x: self.overlayView.bounds.midX, y: self.overlayView.bounds.maxY - 40)
//            self.shouldSetTitle = false
//        }
//    }
    
    func addProductTag(tag: ProductTag) {
        let view = DragScaleAndRotateView(frame: CGRect(origin: self.overlayView.center, size: tag.productTagViewHeight), currentScale: 1, type: .productTag, delegate: self)
        
        let productView: ProductTagView = .fromNib()
        productView.configureView(tag: tag)
        view.addSubview(productView)
        productView.snp.makeConstraints({ $0.edges.equalToSuperview() } )
        
        self.overlayView.addSubview(view)
        view.center = self.overlayView.center
    }
    
    func addTextSticker() {
        let view = DragScaleAndRotateView(frame: .zero, currentScale: 1, type: .text(.init(text: "Text")), delegate: self)
        self.overlayView.addSubview(view)
        view.center = self.view.center
        self.editingTxtViewId = view.id
    }
    
    func processAndCreatePostMedia(completion: @escaping (PostMedia?) -> ()) {
        guard let url = self.mediaManager.saveImage(fileName: UUID().uuidString, image: self.previewImg) else { return completion(nil) }
        
        let stickers: [MediaSticker] = self.contentViews.compactMap({ (dragView) -> MediaSticker? in
            guard dragView.type.isIncludedInFffmpeg else { return nil }
            return .init(dragView: dragView)
        })
        
        FFMPEGManager.sharedInstance.buildMedia(url: url, isVideo: false, content: stickers, shouldRotate: self.shouldRotate) { vFile in
            let url = URL(fileURLWithPath: vFile)
            guard let data = try? Data(contentsOf: url), let img = UIImage(data: data) else { return }
            
            completion(.init(url: url, preview: img, mediaType: .image, productTags: self.productTags))
        }
    }
}

extension MediaEditingEditorViewController: TextStickerEditionDelegate {
    func editingDoneWith(stickerId: UUID, newTextInfo: TextInfo) {
        self.editingTxtViewId = nil
        self.contentViews.first(where: { $0.id == stickerId })?.changeTextInfo(newTextInfo: newTextInfo)
    }
}


extension MediaEditingEditorViewController: DragScalePositionDelegate {
    func viewDragStarted(view: DragScaleAndRotateView) {
        self.trashView.isHidden = false
        self.contentViews.forEach({ $0.clearSelection() })
        self.delegate?.shouldSetScrollEnable(enable: false)
    }
    
    func viewPositionChanged(view: DragScaleAndRotateView, touchPoint: CGPoint) {
        if (self.trashView.frame.contains(touchPoint)) {
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
        self.delegate?.shouldSetScrollEnable(enable: true)
    }
    
    func viewDidSelect(view: DragScaleAndRotateView) {
        guard case .text(let textInfo) = view.type else { return }
        let vc = TextStickerEditionViewController.newInstance(stickerId: view.id, textInfo: textInfo, delegate: self)
        self.present(vc, animated: true)
    }
}
