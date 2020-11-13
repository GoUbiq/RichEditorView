//
//  MediaViewingCollectionViewCell.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-11-13.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class MediaViewingCollectionViewCell: UICollectionViewCell {
    static let identifier = "MediaViewingCollectionViewCell"
    
    @IBOutlet private weak var imgView: UIImageView!
    
    private var media: Media? {
        didSet {
            if self.media?.id != oldValue?.id {
                self.insertProductTags()
            }
        }
    }
    
    private var tagViews: [UIView] {
        return self.imgView.subviews.compactMap({ $0 as? ProductTagView })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgView.isUserInteractionEnabled = true

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleTagsVisibility))
        self.imgView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func toggleTagsVisibility() {
        self.tagViews.forEach({ $0.isHidden.toggle() })
    }
    
    func configureCell(media: Media) {
        self.media = media

        switch media.type {
        case .image:
            self.imgView.sd_setImage(with: URL(string: media.url))
        default: return
        }
    }
    
    func insertProductTags() {
        self.imgView.subviews.forEach({ ($0 as? ProductTagView)?.removeFromSuperview() })
        
        for tag in self.media?.productTags ?? [] {
            let view: ProductTagView = .fromNib()
            view.configureView(tag: tag)
            self.imgView.addSubview(view)
            view.frame.size = tag.productTagViewHeight
            view.frame.origin = .init(x: (self.frame.width * CGFloat(tag.positionX)), y: ((self.frame.height * CGFloat(tag.positionY))))
        }
    }
}
