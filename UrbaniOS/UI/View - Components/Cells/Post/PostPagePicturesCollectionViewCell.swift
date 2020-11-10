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
                self.imageSlide.layoutSubviews()
                self.insertProductTags()
            }
        }
    }
    
    private var tagViews: [UIView] {
        return self.imageSlide.scrollView.subviews.compactMap({ $0 as? ProductTagView })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let pageIndicator = UIPageControl()
        pageIndicator.pageIndicatorTintColor = UIColor.systemGray3
        pageIndicator.currentPageIndicatorTintColor = UIColor.label
        self.imageSlide.pageIndicatorPosition = .init(horizontal: .center, vertical: .customUnder(padding: 10))
        self.imageSlide.contentScaleMode = .scaleAspectFill
        self.imageSlide.pageIndicator = pageIndicator
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleTagsVisibility))
        self.imageSlide.addGestureRecognizer(gestureRecognizer)
    }

    func insertProductTags() {
        self.imageSlide.scrollView.subviews.forEach({ ($0 as? ProductTagView)?.removeFromSuperview() })

        guard !(self.imageSlide.scrollView.subviews.contains(where: { $0 is ProductTagView })) else { return }
        let viewWidth = self.imageSlide.scrollView.bounds.width
        
        for (idx, media) in self.medias.enumerated() {
            let startingX = viewWidth * CGFloat(idx)
            let views = media.productTags.map { (tag) -> (ProductTagView)  in
                let view: ProductTagView = .fromNib()
                view.frame = .init(origin: .init(x: (viewWidth * CGFloat(tag.positionX)) + startingX, y: self.imageSlide.frame.height * CGFloat(tag.positionY)), size: tag.productTagViewHeight)
                view.configureView(tag: tag)
                return view
            }
            
            views.forEach {
                self.imageSlide.scrollView.addSubview($0)
            }
        }
    }
    
    func configureCell(medias: [Media]) {
        self.medias = medias
    }
    
    @objc private func toggleTagsVisibility() {
        self.tagViews.forEach({ $0.isHidden.toggle() })
    }
}
