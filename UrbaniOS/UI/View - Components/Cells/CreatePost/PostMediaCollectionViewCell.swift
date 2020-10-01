//
//  PostMediaCollectionViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-30.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class PostMediaCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostMediaCollectionViewCell"
    
    @IBOutlet private weak var videoIndicator: UIImageView!
    @IBOutlet private weak var img: UIImageView!

    private var delegate: MediaManagementDelegate? = nil
    private var media: PostMedia? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
    }
    
    func configureCell(data: PostMedia, delegate: MediaManagementDelegate) {
        self.media = data
        self.delegate = delegate
        self.img.image = data.preview
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        guard let media = self.media else { return }
        self.delegate?.didDeleteMedia(media: media)
    }
}
