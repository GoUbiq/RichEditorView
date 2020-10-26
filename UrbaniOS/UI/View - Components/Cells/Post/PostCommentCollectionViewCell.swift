//
//  PostCommentCollectionViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-23.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class PostCommentCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCommentCollectionViewCell"
    
    @IBOutlet private weak var userImg: CircleImageView!
    @IBOutlet private weak var userName: UILabel!
    @IBOutlet private weak var comment: UILabel!
    @IBOutlet private weak var timeAgoLabel: UILabel!
    @IBOutlet private weak var likeCount: UILabel!
    
    func configureCell(comment: Comment) {
        self.userImg.sd_setImage(with: URL(string: comment.author.imageUrl))
        self.userName.text = comment.author.name
        self.comment.text = comment.body
        self.timeAgoLabel.text = comment.createdAt.timeAgoDisplay()
        self.likeCount.text = "\(comment.likeCountStr) Likes"
    }
}
