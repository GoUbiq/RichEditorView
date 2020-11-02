//
//  Product.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation

struct Product {
    let id: String
    let title: String
    var rating: Int? = nil
    
    init(product: GraphQlProduct) {
        self.id = product.id
        self.title = product.title
        self.rating = 3
    }
}
