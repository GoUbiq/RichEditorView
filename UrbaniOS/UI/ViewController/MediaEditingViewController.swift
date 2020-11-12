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

    class func newInstance(imgs: [UIImage], shouldRotate: Bool = false, delegate: MediaManagementDelegate) -> MediaEditingViewController {
        let instance = templateStoryboard.instantiateViewController(withIdentifier: self.identifier) as! MediaEditingViewController
        instance.images = imgs
        instance.delegate = delegate
        instance.shouldRotate = shouldRotate
        return instance
    }

    private var mediaManager: MediaManager {
        return .sharedInstance
    }
    private var shouldSetTitle: Bool = true
    private var images: [UIImage]!
    private var delegate: MediaManagementDelegate? = nil
    private var imgPageControllerVC: MediaEditingPageViewController?
    private var shouldRotate: Bool = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MediaEditingPageViewController {
            vc.images = self.images
            vc.shouldRotate = self.shouldRotate
            vc.pageDidChangeHandler = {
                self.configureNavTitle()
            }
            self.imgPageControllerVC = vc
        }
    }
    
    private lazy var productPickerVC: UINavigationController = {
        let vc = ProductTagPickerSearchResultViewController.newInstance(delegate: self)
        return SearchViewController.newInstance(searchResultVC: vc)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.configureNavTitle()
        self.navigationItem.rightBarButtonItem = .init(title: "Create", style: .plain, target: self, action: #selector(self.createButtonPressed))
//        self.img.image = self.image
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func configureNavTitle() {
        self.navigationItem.title = "\((self.imgPageControllerVC?.currentIndex ?? 0) + 1) / \(self.images.count)"
    }
    
    @IBAction func tagProductButtonPressed(_ sender: Any) {
        self.present(self.productPickerVC, animated: true)
    }

    @IBAction func addTextButtonPressed(_ sender: Any) {
        self.imgPageControllerVC?.addTextSticker()
    }

    @objc func createButtonPressed() {
        let hud = Utils.showMessageHud(onViewController: self)
        self.imgPageControllerVC?.processAllMedias() { medias in
            Utils.dismissMessageHud(hud)
            medias.forEach({ self.delegate?.didCreateMedia(media: $0) })
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: false)
        }
    }
}

extension MediaEditingViewController: ProductTagPickerDelegate {
    func didSelect(tag: ProductTag) {
        self.productPickerVC.dismiss(animated: true)
        self.imgPageControllerVC?.addProductTagOnCurrent(tag: tag)
    }
}


