//
//  TextStickerColourPickerView.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-11-10.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

protocol TextStickerColourPickerDelegate: class {
    func didSelectNewColour(color: UIColor)
}

class TextStickerColourPickerView: UIView {
    static let identifier = "TextStickerColourPickerView"
    
    @IBOutlet private var collectionView: UICollectionView!
    
    private var colours: [UIColor] = [.black, .white, .yellow, .red, .blue, .brown, .cyan, .darkGray, .lightGray, .gray, .green, .magenta, .orange, .purple]

    var delegate: TextStickerColourPickerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.setup()
    }

    init() {
        super.init(frame: CGRect.zero)
//        self.setup()
    }
    
    func configureView() {
        //Cell registration
        self.collectionView.register(TextStickerColourPickerCollectionViewCell.loadedNib(), forCellWithReuseIdentifier: TextStickerColourPickerCollectionViewCell.identifier)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.reloadData()
    }
}

extension TextStickerColourPickerView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextStickerColourPickerCollectionViewCell.identifier, for: indexPath) as! TextStickerColourPickerCollectionViewCell
        cell.configureCell(color: self.colours[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectNewColour(color: self.colours[indexPath.row])
    }
}
