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
    
    private var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = true
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: .zero)
    }
    
    func configureView(product: Product) {
        self.product = product
        self.productName.text = product.title
    }
}
