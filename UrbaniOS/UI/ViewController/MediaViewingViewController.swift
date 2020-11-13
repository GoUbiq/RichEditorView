//
//  MediaViewingViewController.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-11-12.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class MediaViewingViewController: UIViewController {
    private static let identifier = "MediaViewingViewController"
    
    @IBOutlet private weak var imageView: UIImageView!
    
    class func newInstance(media: Media) -> MediaViewingViewController {
        let instance = mediaStoryboard.instantiateViewController(withIdentifier: self.identifier) as! MediaViewingViewController
        instance.media = media
        return instance
    }
    
    private var media: Media!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.sd_setImage(with: URL(string: self.media.url))
    }
}
