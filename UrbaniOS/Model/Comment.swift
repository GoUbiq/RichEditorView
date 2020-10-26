//
//  Comment.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-23.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation

struct Comment {
    var id: String
    var body: String
    var likeCountStr: String
    var userHasLiked: Bool
    var author: User
    var createdAt: Date = Date()
}

extension Comment {
    static var mockedComment: Comment {
        return .init(id: "", body: "THIS IS A COMMENT YO", likeCountStr: "1.2k", userHasLiked: false, author: .mockedUser)
    }
    
    static var mockedComments: [Comment] {
        return (0...10).map({ _ in .mockedComment })
    }
}
