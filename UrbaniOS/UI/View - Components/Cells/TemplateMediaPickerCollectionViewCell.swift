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
    @IBOutlet private weak var dimmingView: UIView!
    @IBOutlet private weak var labelHolderView: CircleImageView!
    @IBOutlet private weak var nbLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.labelHolderView.layer.borderWidth = 1
        self.labelHolderView.layer.borderColor = UIColor.white.cgColor
    }
    
    func configureCell(media: PHAsset, isEnabled: Bool, selectionNb: Int?) {
        self.img.fetchImage(asset: media, contentMode: .aspectFill, targetSize: self.img.bounds.size)
        self.dimmingView.isHidden = isEnabled
        self.nbLabel.isHidden = true
        if let nb = selectionNb {
            self.nbLabel.text = "\(nb)"
            self.nbLabel.isHidden = false
        }
    }
}

