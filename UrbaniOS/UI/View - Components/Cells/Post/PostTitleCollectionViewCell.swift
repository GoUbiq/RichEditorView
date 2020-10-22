//
//  PostTitleCollectionViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-22.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit


class PostTitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostTitleCollectionViewCell"
    
    @IBOutlet private weak var title: UILabel!
    
    func configureCell(title: String) {
        self.title.text = title
    }
}
