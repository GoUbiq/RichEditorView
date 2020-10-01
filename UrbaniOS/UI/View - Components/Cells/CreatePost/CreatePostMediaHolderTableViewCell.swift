//
//  CreatePostMediaHolderTableViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-29.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class CreatePostMediaHolderTableViewCell: UITableViewCell, ConfigurableCell {
    
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    
    private var cellInfo: [MediaHolderType] = []
    
    func configure(data: [MediaHolderType]) {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.cellInfo = data
        
        self.collectionView.reloadData()
    }
}

extension CreatePostMediaHolderTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let elem = self.cellInfo[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: elem.cellID, for: indexPath)
        
        switch elem {
        case .action(let action):
            if let cell = cell as? CreatePostActionCollectionViewCell {
                cell.configureCell(data: action)
            }
        case .media(let postMedia, let delegate):
            if let cell = cell as? PostMediaCollectionViewCell {
                cell.configureCell(data: postMedia, delegate: delegate)
            }
        }
        
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellInfo[indexPath.row].clickAction?()
    }
}

extension CreatePostMediaHolderTableViewCell {
    struct PostMediaAction {
        var image: UIImage
        var title: String
        var action: DefaultBlock? = nil
    }
    
    enum MediaHolderType {
        case action(PostMediaAction)
        case media(PostMedia, MediaManagementDelegate)
        
        var cellID: String {
            switch self {
            case .action: return "CreatePostActionCollectionViewCell"
            case .media: return "PostMediaCollectionViewCell"
            }
        }
        
        var clickAction: DefaultBlock? {
            switch self {
            case .action(let action): return action.action
            default: return nil
            }
        }
    }
}
