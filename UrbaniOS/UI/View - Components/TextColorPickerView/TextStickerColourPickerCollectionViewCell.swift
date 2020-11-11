//
//  TextStickerColourPickerCollectionViewCell.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-11-10.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class TextStickerColourPickerCollectionViewCell: UICollectionViewCell {
    static let identifier = "TextStickerColourPickerCollectionViewCell"
    
    class func loadedNib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    func configureCell(color: UIColor) {
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.backgroundColor = color
    }
}
