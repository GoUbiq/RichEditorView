//
//  CommentCountAndPostCommentCollectionViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-23.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class CommentCountAndPostCommentCollectionViewCell: UICollectionViewCell {
    static let identifier = "CommentCountAndPostCommentCollectionViewCell"
    
    @IBOutlet private weak var nbComments: UILabel!
    private var delegate: CommentCellsDelegate? = nil

    func configureCell(nbComment: Int, delegate: CommentCellsDelegate) {
        self.nbComments.text = "\(nbComment) Comments"
        self.delegate = delegate
    }
    
    @IBAction private func commentButtonPressed(_ sender:  Any) {
        self.delegate?.commentButtonPressed()
    }
}
