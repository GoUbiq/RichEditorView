//
//  MediaEditingViewController.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-11-11.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class MediaEditingViewController: UIViewController {
    static let identifier = "MediaEditingViewController"

    class func newInstance(imgs: [UIImage], delegate: MediaManagementDelegate) -> MediaEditingViewController {
        let instance = templateStoryboard.instantiateViewController(withIdentifier: self.identifier) as! MediaEditingViewController
        instance.images = imgs
        instance.delegate = delegate
        return instance
    }

    private var mediaManager: MediaManager {
        return .sharedInstance
    }
    private var shouldSetTitle: Bool = true
    private var images: [UIImage]!
    private var delegate: MediaManagementDelegate? = nil
    private var imgPageControllerVC: MediaEditingPageViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MediaEditingPageViewController {
            vc.images = self.images
            self.imgPageControllerVC = vc
        }
    }
    
    private lazy var productPickerVC: UINavigationController = {
        let vc = ProductTagPickerSearchResultViewController.newInstance(delegate: self)
        return SearchViewController.newInstance(searchResultVC: vc)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationItem.rightBarButtonItem = .init(title: "Create", style: .plain, target: self, action: #selector(self.createButtonPressed))
//        self.img.image = self.image
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        if self.contentViews.isEmpty, self.shouldSetTitle {
//            let textInfo: TextInfo = .init(text: "VS", isTitle: true)
//            let view = DragScaleAndRotateView.init(frame: .zero, currentScale: 1, type: .text(textInfo), delegate: self)
//            self.overlayView.addSubview(view)
//
//            view.changeTextInfo(newTextInfo: textInfo)
//            view.center = .init(x: self.overlayView.bounds.midX, y: self.overlayView.bounds.maxY - 40)
//            view.configurePositionRatio()
//            self.shouldSetTitle = false
//        }
    }

    @IBAction func tagProductButtonPressed(_ sender: Any) {
        self.present(self.productPickerVC, animated: true)
    }

    @IBAction func addTextButtonPressed(_ sender: Any) {
        self.imgPageControllerVC?.addTextSticker()
    }

    @objc func createButtonPressed() {
//        guard let url = self.mediaManager.saveImage(fileName: UUID().uuidString, image: self.image) else { return }
//
//        let stickers = self.contentViews.compactMap({ (dragView) -> MediaSticker? in
//            guard dragView.type.isIncludedInFffmpeg else { return nil }
//            return .init(dragView: dragView)
//        })
//
//        FFMPEGManager.sharedInstance.buildMedia(url: url, isVideo: false, content: stickers) { vFile in
//            let url = URL(fileURLWithPath: vFile)
//            guard let data = try? Data(contentsOf: url), let img = UIImage(data: data) else { return }
//            self.delegate?.didCreateMedia(media: .init(url: url, preview: img, mediaType: .image, productTags: self.productTags))
//            self.navigationController?.dismiss(animated: true)
//        }
    }
}

extension MediaEditingViewController: ProductTagPickerDelegate {
    func didSelect(tag: ProductTag) {
        self.productPickerVC.dismiss(animated: true)
        self.imgPageControllerVC?.addProductTagOnCurrent(tag: tag)
    }
}

extension MediaEditingViewController: TextStickerEditionDelegate {
    func editingDoneWith(stickerId: UUID, newTextInfo: TextInfo) {
//        self.contentViews.first(where: { $0.id == stickerId })?.changeTextInfo(newTextInfo: newTextInfo)
    }
}


