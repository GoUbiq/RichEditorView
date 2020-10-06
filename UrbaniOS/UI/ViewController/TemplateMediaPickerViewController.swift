//
//  TemplateMediaPickerViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-06.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import Photos

class TemplateMediaPickerViewController: UIViewController {
    static let identifier = "TemplateMediaPickerViewController"
    
    @IBOutlet private weak var collectionView: UICollectionView!

    class func newInstance() -> UINavigationController {
        let navigation = UINavigationController()
        let instance = templateStoryboard.instantiateViewController(withIdentifier: self.identifier) as! TemplateMediaPickerViewController
        navigation.modalPresentationStyle = .overFullScreen
        navigation.navigationBar.tintColor = .darkGray
        navigation.setViewControllers([instance], animated: false)
        return navigation
    }
    
    private var nextBarButton: UIBarButtonItem? = nil
    private var photos: PHFetchResult<PHAsset> = .init()
    private var mediaManager: MediaManager {
        return MediaManager.sharedInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.allowsMultipleSelection = true
        self.navigationItem.title = "Select medias"
        self.nextBarButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.nextButtonPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(self.dismissView))
        self.navigationItem.rightBarButtonItem = self.nextBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mediaManager.fetchAllLibraryPhotos() {
            self.photos = $0 ?? .init()
            self.collectionView.reloadData()
            self.collectionView.
        }
    }
    
    @objc func nextButtonPressed() {
        
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
        
        cell.configureCell(media: self.photos.object(at: indexPath.row))

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //-3 for 1px space separator
        let size = (collectionView.bounds.width / 4) - 1
        return CGSize(width: size, height: size)
    }
}
