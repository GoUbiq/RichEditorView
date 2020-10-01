//
//  CreatePostActionCollectionViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-29.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit


class CreatePostActionCollectionViewCell: UICollectionViewCell {
    static let identifier = "CreatePostActionCollectionViewCell"
    
    @IBOutlet private weak var img: UIImageView!
    @IBOutlet private weak var txt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
    }
    
    func configureCell(data: CreatePostMediaHolderTableViewCell.PostMediaAction) {
        self.img.image = data.image
        self.txt.text = data.title
    }
}
