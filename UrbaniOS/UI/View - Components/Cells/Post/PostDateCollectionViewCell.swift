//
//  PostDateCollectionViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-23.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class PostDateCollectionViewCell: UICollectionViewCell {
    static let identifer = "PostDateCollectionViewCell"
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    func configureCell(date: Date) {
        self.dateLabel.text = date.timeAgoDisplay()
    }
}
