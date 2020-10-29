//
//  PostViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-22.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import RichEditorView

protocol CommentCellsDelegate: class {
    func commentButtonPressed()
}

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
        case date
        case commentCount
        case comments
        
        var cellID: String {
            switch self {
            case .images: return PostPagePicturesCollectionViewCell.identifier
            case .title: return PostTitleCollectionViewCell.identifier
            case .body: return PostBodyCollectionViewCell.identifier
            case .date: return PostDateCollectionViewCell.identifer
            case .commentCount: return CommentCountAndPostCommentCollectionViewCell.identifier
            case .comments: return PostCommentCollectionViewCell.identifier
            }
        }
    }
    
    private var cells: [[PostCells]] = [[.images, .title, .body, .date]]
    private var critique: Critique!
    private var comments: [Comment] {
        return self.critique.comments
    }
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
        self.loadContent()
    }
    
    private func loadContent() {
        if !self.comments.isEmpty, !(self.cells[safe: 1]?.contains(.comments) ?? false) {
            self.cells.insert([.commentCount, .comments], at: 1)
        }
        
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
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)

            return layout
        }()
        layout.delegate = self
        layout.cellPadding = 5
        layout.numberOfColumns = 1
    }
    
    private func getCellHeight(cell: PostCells, indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        switch cell {
        case .images: return withWidth + 20
        case .body: return self.bodyHeight ?? withWidth
        case .title: return self.critique.title.heightForWidth(width: withWidth - 20, font: .systemFont(ofSize: 17, weight: .semibold)) + 10
        case .date: return self.critique.createdAt.timeAgoDisplay().heightForWidth(width: withWidth - 30, font: .systemFont(ofSize: 15)) + 10
        case .commentCount: return 80
        case .comments:
            let comment = self.critique.comments[indexPath.row - 1]
            return 50 + comment.body.heightForWidth(width: withWidth - 90, font: .systemFont(ofSize: 15))
        }
    }
    
    private func numberOfRowFor(section: Int) -> Int {
        switch section {
        case 1: return 1 + self.comments.count
        default:
            return self.cells[section].count
        }
    }
    
    private func getCellEnum(section: Int, row: Int) -> PostCells {
        switch section {
        case 1: return self.cells[safe: section]?[safe: row] ?? PostCells.comments
        default: return self.cells[section][row]
        }
    }
    
    @IBAction func commentButtonPressed(_ sender: Any) {
        self.commentButtonPressed()
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
        return self.getCellHeight(cell: self.getCellEnum(section: indexPath.section, row: indexPath.row), indexPath: indexPath, withWidth: withWidth)
    }
}

extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfRowFor(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.getCellEnum(section: indexPath.section, row: indexPath.row).cellID, for: indexPath)
        
        if let cell = cell as? PostPagePicturesCollectionViewCell {
            cell.configureCell(medias: self.critique.media)
            return cell
        } else if let cell = cell as? PostBodyCollectionViewCell {
            cell.configureCell(contentHTML: self.critique.descriptionHTML, delegate: self)
            return cell
        } else if let cell = cell as? PostTitleCollectionViewCell {
            cell.configureCell(title: self.critique.title)
            return cell
        } else if let cell = cell as? PostDateCollectionViewCell {
            cell.configureCell(date: self.critique.createdAt)
            return cell
        } else if let cell = cell as? CommentCountAndPostCommentCollectionViewCell {
            cell.configureCell(nbComment: self.comments.count, delegate: self)
            return cell
        } else if let cell = cell as? PostCommentCollectionViewCell {
            cell.configureCell(comment: self.comments[indexPath.row - 1])
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

extension PostViewController: CommentCellsDelegate {
    func commentButtonPressed() {
        let vc = PostCommentViewController.newInstance(critiqueId: self.critique.id, delegate: self)
        self.present(vc, animated: false)
    }
}

extension PostViewController: PostCommentDelegate {
    func didPostComment(comment: Comment) {
        self.critique.comments.insert(comment, at: 0)
        self.loadContent()
    }
}
