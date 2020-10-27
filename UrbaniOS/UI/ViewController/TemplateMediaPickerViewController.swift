//
//  TemplateMediaPickerViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-06.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import Photos
import ImageScrollView

class TemplateMediaPickerViewController: UIViewController {
    static let identifier = "TemplateMediaPickerViewController"
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet var imgPreviews: [ImageScrollView]!

    class func newInstance(delegate: MediaManagementDelegate) -> UINavigationController {
        let navigation = UINavigationController()
        let instance = templateStoryboard.instantiateViewController(withIdentifier: self.identifier) as! TemplateMediaPickerViewController
        instance.delegate = delegate
        navigation.modalPresentationStyle = .overFullScreen
        navigation.navigationBar.tintColor = .darkGray
        navigation.setViewControllers([instance], animated: false)
        return navigation
    }
    
    private var nextBarButton: UIBarButtonItem? = nil
    private var photos: PHFetchResult<PHAsset> = .init()
    private var delegate: MediaManagementDelegate? = nil
    private var mediaManager: MediaManager {
        return MediaManager.sharedInstance
    }
    
    private struct SelectedMedia {
        var media: PHAsset
        var contentOffSet: CGPoint
        var zoomScale: CGFloat
    }
    
    private var selectedMedia: [SelectedMedia]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgPreviews.forEach {
            $0.setup()
            $0.imageContentMode = .aspectFill
            $0.imageScrollViewDelegate = self
        }

        self.collectionView.allowsMultipleSelection = true
        self.navigationItem.title = "Select medias"
        self.nextBarButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.nextButtonPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nav-close"), style: .plain, target: self, action: #selector(self.dismissView))
        self.navigationItem.rightBarButtonItem = self.nextBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mediaManager.fetchAllLibraryPhotos() {
            self.photos = $0 ?? .init()
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Private
    private func updateNavigationTitle() {
        if self.selectedMedia.isEmpty {
            self.navigationItem.title = "Select media"
        } else {
            self.navigationItem.title = "\(self.selectedMedia.count) / 2"
        }
        self.nextBarButton?.isEnabled = self.selectedMedia.count == 2
    }
    
    private func mergeImages() -> UIImage? {
        guard self.selectedMedia.count == 2 else { return nil }
        
        let images = self.imgPreviews.compactMap({ $0.zoomView?.image?.crop(rect: $0.visibleRect)?.resizeImage(targetSize: .init(width: 500, height: 500)) })
        
        return images.combineLeftToRight()
    }
    
    private func updateSelectedImages() {
        self.imgPreviews.enumerated().forEach { idx, view in
            if let selected = self.selectedMedia[safe: idx] {
                self.mediaManager.fetchImage(asset: selected.media) { img in
                    view.display(image: img)
                    view.zoomScale = selected.zoomScale
                    view.setContentOffset(selected.contentOffSet, animated: false)
                }
            } else {
                view.display(image: UIImage())
            }
        }
    }
    
    //MARK: - IBActions
    @objc func nextButtonPressed() {
        guard let img = self.mergeImages() else { return }
        let vc = TemplateEditingViewController.newInstance(img: img, delegate: self.delegate!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
}

extension TemplateMediaPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TemplateMediaPickerCollectionViewCell.identifier, for: indexPath) as! TemplateMediaPickerCollectionViewCell
        
        let photo = self.photos.object(at: indexPath.row)
        var nbPhoto: Int? = nil
        if let idx = self.selectedMedia.firstIndex(where: { $0.media == photo  }) {
            nbPhoto = idx + 1
        }
        let isEnabled = (self.selectedMedia.count < 2) || self.selectedMedia.contains(where: { $0.media == photo })
        cell.configureCell(media: photo, isEnabled: isEnabled, selectionNb: nbPhoto)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //-3 for 1px space separator
        let size = (collectionView.bounds.width / 4) - 1
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = self.photos.object(at: indexPath.row)
        
        guard self.selectedMedia.count < 2 || self.selectedMedia.contains(where: { $0.media == obj }) else { return }

        if self.selectedMedia.contains(where: { $0.media == obj }) {
            self.selectedMedia.removeAll(where: { obj == $0.media })
        } else {
            self.selectedMedia.append(.init(media: obj, contentOffSet: .zero, zoomScale: 0))
        }
        
        self.updateNavigationTitle()
        self.updateSelectedImages()
        self.collectionView.reloadData()
    }
}

extension TemplateMediaPickerViewController: ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {}
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard let idx = self.imgPreviews.firstIndex(where: { $0 === scrollView }), (idx + 1) <= self.selectedMedia.count else { return }
        self.selectedMedia[idx].contentOffSet = scrollView.contentOffset
        self.selectedMedia[idx].zoomScale = scrollView.zoomScale
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let idx = self.imgPreviews.firstIndex(where: { $0 === scrollView }), (idx + 1) <= self.selectedMedia.count else { return }
        self.selectedMedia[idx].contentOffSet = scrollView.contentOffset
        self.selectedMedia[idx].zoomScale = scrollView.zoomScale
    }
}
