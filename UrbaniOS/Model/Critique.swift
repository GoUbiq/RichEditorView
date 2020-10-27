//
//  Critique.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-16.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import UIKit

struct Critique {
    var id: String
    var title: String
    var shortDescription: String?
    var descriptionHTML: String
    var author: User
    var media: [Media] = []
    var defaultMedia: Media
    var createdAt: Date = Date()
    var comments: [Comment] = Comment.mockedComments
    
    init(critique: GraphQlCritique) {
        self.id = critique.id
        self.title = critique.title
        self.descriptionHTML = critique.descriptionHtml
        self.author = User(user: critique.author.fragments.graphQlUser)
        self.shortDescription = critique.shortdescription
        self.media = critique.media.map({ .init(media: $0.fragments.graphQlMedia) })
        self.defaultMedia = .init(media: critique.defaultMedia.fragments.graphQlMedia)
    }
}

