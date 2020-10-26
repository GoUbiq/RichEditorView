//
//  PostPagePicturesCollectionViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-21.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import ImageSlideshow

class PostPagePicturesCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostPagePicturesCollectionViewCell"
    
    @IBOutlet private weak var imageSlide: ImageSlideshow!
    
    private var medias: [Media] = [] {
        didSet {
            if self.medias.count != oldValue.count {
                self.imageSlide.setImageInputs(self.medias.compactMap({ SDWebImageSource(urlString: $0.url) }))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let pageIndicator = UIPageControl()
        pageIndicator.pageIndicatorTintColor = UIColor.systemGray3
        pageIndicator.currentPageIndicatorTintColor = UIColor.label
        self.imageSlide.pageIndicatorPosition = .init(horizontal: .center, vertical: .customUnder(padding: 10))
        self.imageSlide.contentScaleMode = .scaleAspectFill
        self.imageSlide.pageIndicator = pageIndicator
    }
    
    func configureCell(medias: [Media]) {
        self.medias = medias
    }
}
