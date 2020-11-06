//
//  ProductManager.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-02.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation

class ProductManager {
    static var sharedInstance = ProductManager()

    func getProducts(completion: @escaping (([Product]?) -> ())) {
        apollo.fetch(query: ProductsQuery(first: 10)) { result, error in
            guard let result = result?.data?.products.edges else {
                completion(nil)
                return
            }

            completion(result.map({ Product(product: $0.node.fragments.graphQlProduct) }))
        }
    }
    
    func createProduct(title: String, url: String, completion: @escaping ((Product?) -> ())) {
        let input: ProductCreateInput = .init(title: title, affiliateUrl: url)
        apollo.perform(mutation:  CreateProductMutation(input: input)) { result, error in
            guard let result = result?.data?.createProduct.fragments.graphQlProduct else { return completion(nil) }
            completion(.init(product: result))
        }
    }
}
