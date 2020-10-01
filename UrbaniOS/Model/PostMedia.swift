//
//  PostMedia.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-30.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

struct PostMedia {
    var id: UUID = UUID()
    var url: URL
    var preview: UIImage
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

