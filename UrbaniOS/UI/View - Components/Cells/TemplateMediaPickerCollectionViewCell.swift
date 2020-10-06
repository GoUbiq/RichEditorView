//
//  TemplateMediaPickerCollectionViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-06.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import Photos

class TemplateMediaPickerCollectionViewCell: UICollectionViewCell {
    static let identifier = "TemplateMediaPickerCollectionViewCell"
    
    @IBOutlet private weak var img: UIImageView!
    
    func configureCell(media: PHAsset) {
        self.img.fetchImage(asset: media, contentMode: .aspectFill, targetSize: self.img.bounds.size)
    }
}

