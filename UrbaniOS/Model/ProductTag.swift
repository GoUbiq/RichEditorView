//
//  ProductTag.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-29.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import UIKit

struct ProductTag {
    var id: String
    var rating: Int?
    var product: Product
    var positionX: Double
    var positionY: Double

    init(productTag: GraphQlProductTag) {
        self.id = productTag.id
        self.rating = (productTag.rating == 0) ? nil : productTag.rating
        self.positionX = productTag.positionX
        self.positionY = productTag.positionY
        self.product = .init(product: productTag.product.fragments.graphQlProduct)
    }
    
    init(rating: Int?, positionX: Double, positionY: Double, product: Product) {
        self.id = UUID().uuidString
        self.rating = rating
        self.positionX = positionX
        self.positionY = positionY
        self.product = product
    }
    
    var productTagViewHeight: CGSize {
        let appplicableWidth: CGFloat = 140
        let initialHeight = 20 + ((self.rating == nil) ? 0 : 25)
        return .init(width: 200, height: self.product.title.heightForWidth(width: appplicableWidth, font: .systemFont(ofSize: 13), nbOfLines: 2) + CGFloat(initialHeight))
    }
}
