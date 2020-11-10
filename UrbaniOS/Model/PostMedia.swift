//
//  PostMedia.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-30.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

struct Media {
    var id: String
    var position: Int?
    var url: String
    var width: Double
    var height: Double
    var type: MediaType
    var productTags: [ProductTag]
    
    init(media: GraphQlMedia) {
        self.id = media.id
        self.position = media.position
        self.url = media.srcUrl
        self.width = media.width
        self.height = media.height
        self.type = media.mediaType
        self.productTags = media.tags.compactMap({ ProductTag(productTag: $0.fragments.graphQlProductTag) })
    }
}

struct PostMedia {
    var id: UUID = UUID()
    var url: URL
    var preview: UIImage
    var mediaType: MediaType
    var productTags: [ProductTag] = []
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

struct UploadedMedia {
    var url: String
    var productTags: [ProductTag]
}
