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
    
    init(media: GraphQlMedia) {
        self.id = media.id
        self.position = media.position
        self.url = media.srcUrl
        self.width = media.width
        self.height = media.height
        self.type = media.mediaType
    }
}


struct PostMedia {
    var id: UUID = UUID()
    var url: URL
    var preview: UIImage
    var mediaType: MediaType
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

