//
//  ProductTag.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-29.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation

struct ProductTag {
    var id: String
    var rating: Int
    var product: Product = .init(product: .init(id: "", title: "Product", affiliateUrl: "", tags: []))
    var positionX: Double
    var positionY: Double

    init(productTag: GraphQlProductTag) {
        self.id = productTag.id
        self.rating = productTag.rating
        self.positionX = productTag.positionX
        self.positionY = productTag.positionY
    }
}
