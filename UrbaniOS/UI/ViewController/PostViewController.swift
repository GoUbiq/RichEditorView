//
//  PostViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-22.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import RichEditorView

class PostViewController: UIViewController {
    static let identifier = "PostViewController"
    
    @IBOutlet private weak var collectionView: UICollectionView!

    class func newInstance(critique: Critique) -> PostViewController {
        let instance = postStoryboard.instantiateViewController(withIdentifier: self.identifier) as! PostViewController
        instance.critique = critique
        return instance
    }
    
    enum PostCells {
        case images
        case title
        case body
        
        var cellID: String {
            switch self {
            case .images: return PostPagePicturesCollectionViewCell.identifier
            case .title: return PostTitleCollectionViewCell.identifier
            case .body: return PostBodyCollectionViewCell.identifier
            }
        }
    }
    
    private var cells: [PostCells] = [.images, .title, .body]
    private var critique: Critique!
    private var bodyHeight: CGFloat? = nil {
        didSet {
            if oldValue != self.bodyHeight {
                self.collectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
    }
    
    private func setupLayout() {
        let layout: PinterestLayout = {
            if let layout = self.collectionView.collectionViewLayout as? PinterestLayout {
                return layout
            }
            let layout = PinterestLayout()

            self.collectionView?.collectionViewLayout = layout

            return layout
        }()
        layout.delegate = self
        layout.cellPadding = 5
        layout.numberOfColumns = 1
    }
    
    private func getCellHeight(cell: PostCells, withWidth: CGFloat) -> CGFloat {
        switch cell {
        case .images: return withWidth + 20
        case .body: return self.bodyHeight ?? withWidth
        case .title: return self.critique.title.heightForWidth(width: withWidth - 20, font: .systemFont(ofSize: 17, weight: .semibold)) + 10
        }
    }
}

extension PostViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return self.getCellHeight(cell: self.cells[indexPath.row], withWidth: withWidth)
    }
}

extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cells[indexPath.row].cellID, for: indexPath)
        
        if let cell = cell as? PostPagePicturesCollectionViewCell {
            cell.configureCell(medias: self.critique.media)
            return cell
        } else if let cell = cell as? PostBodyCollectionViewCell {
            cell.configureCell(contentHTML: self.critique.descriptionHTML, delegate: self)
            return cell
        } else if let cell = cell as? PostTitleCollectionViewCell {
            cell.configureCell(title: self.critique.title)
            return cell
        }
        
        return cell
    }
}

extension PostViewController: RichEditorDelegate {
    func richEditor(_ editor: RichEditorView, heightDidChange height: Int) {
        self.bodyHeight = CGFloat(height)
    }
}
