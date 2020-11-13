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
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    private var medias: [Media] = [] {
        didSet {
            self.pageControl.numberOfPages = self.medias.count
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.systemGray3
        self.pageControl.currentPageIndicatorTintColor = UIColor.label
    }

    func configureCell(medias: [Media]) {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.medias = medias
        self.collectionView.reloadData()
    }
}

extension PostPagePicturesCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaViewingCollectionViewCell.identifier, for: indexPath) as! MediaViewingCollectionViewCell
        cell.configureCell(media: self.medias[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.bounds.width, height: self.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.pageControl.currentPage = indexPath.row
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
