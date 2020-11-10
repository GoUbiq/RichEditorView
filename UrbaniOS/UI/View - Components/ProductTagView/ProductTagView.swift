//
//  ProductTagView.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-01.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class ProductTagView: UIView {
    static let identifier = "ProductTagView"
    
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var stackContainerView: UIView!
    @IBOutlet private weak var rightArrow: UIImageView!
    @IBOutlet private weak var productRatingView: ProductRatingView!
    
    private var product: Product!
    private(set) var productTag: ProductTag!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.stackContainerView.layer.borderColor = UIColor.white.cgColor
        self.stackContainerView.layer.borderWidth = 1
        self.stackContainerView.roundedCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner], radius: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: .zero)
    }
    
    func configureView(tag: ProductTag) {
        self.productTag = tag
        self.product = tag.product
        self.productName.text = tag.product.title
        self.productRatingView.isHidden = true
        if let rating = tag.rating {
            self.productRatingView.isHidden = false
            self.productRatingView.configureView(rating: rating)
        }
    }
}
