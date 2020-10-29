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
    var createdAt: Date
    
    init(comment: GraphQlComment) {
        self.id = comment.id
        self.body = comment.body
        self.likeCountStr = comment.likeCount
        self.userHasLiked = comment.userHasLiked
        self.author = .init(user: comment.author.fragments.graphQlUser)
        self.createdAt = DateFormatter.iso8601WithMilliseconds.date(from: comment.createdAt) ?? Date()
    }
}
