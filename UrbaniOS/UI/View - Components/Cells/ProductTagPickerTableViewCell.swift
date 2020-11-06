//
//  ProductTagPickerTableViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-02.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class ProductTagPickerTableViewCell: UITableViewCell {
    static let identifier = "ProductTagPickerTableViewCell"
    
    @IBOutlet private weak var productTitle: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var productRatingView: ProductRatingView!
    
    private var delegate: ProductRatingDelegate? = nil
    
    func configureCell(product: Product, isExpended: Bool, delegate: ProductRatingDelegate) {
        self.delegate = delegate
        self.productRatingView.configureView(rating: 0, selectedRateColor: .systemYellow, editingEnabled: true, delegate: delegate)
        self.ratingView.isHidden = !isExpended
        self.productTitle.text = product.title
    }
    
    @IBAction func notNowButtonPressed(_ sender: Any) {
        self.delegate?.rateDidChange(rating: nil)
    }
}
