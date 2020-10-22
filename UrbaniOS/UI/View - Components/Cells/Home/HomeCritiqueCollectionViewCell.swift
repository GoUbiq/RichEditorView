//
//  HomeCritiqueCollectionViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-21.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import UIKit

class HomeCritiqueCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCritiqueCollectionViewCell"
    
    @IBOutlet private weak var productTitle: UILabel!
    @IBOutlet private weak var userImg: CircleImageView!
    @IBOutlet private weak var userName: UILabel!
    @IBOutlet private weak var preview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 1
    }
    
    func configureCell(critique: Critique) {
        self.preview.sd_setImage(with: URL(string: critique.defaultMedia.url))
        self.productTitle.text = critique.title
        self.userName.text = critique.author.name
        self.userImg.sd_setImage(with: URL(string: critique.author.imageUrl))
    }
}
