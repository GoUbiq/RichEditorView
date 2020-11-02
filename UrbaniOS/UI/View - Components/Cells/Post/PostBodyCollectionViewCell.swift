//
//  PostBodyCollectionViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-21.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class PostBodyCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostBodyCollectionViewCell"
    
    @IBOutlet private weak var richView: RichEditorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.richView.editingEnabled = false
        self.richView.isScrollEnabled = false
    }
    
    func configureCell(contentHTML: String, delegate: RichEditorDelegate) {
        self.richView.delegate = delegate
        self.richView.html = contentHTML
    }
}
