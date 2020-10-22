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
    var shortDescription: String
    var descriptionHTML: String
    var author: User
    var media: [Media] = []
    var defaultMedia: Media
}

extension Critique {
    static var urlImages: [String] = [
        "https://s3.amazonaws.com/critq.shoptgt.com/throw.png",
        "https://s3.amazonaws.com/critq.shoptgt.com/slippers.png",
        "https://s3.amazonaws.com/critq.shoptgt.com/calm_title.png",
        "https://s3.amazonaws.com/critq.shoptgt.com/calm_3.png",
        "https://s3.amazonaws.com/critq.shoptgt.com/calm_4.png"
    ]
    
    static var medias: [Media] = Critique.urlImages.map({ Media(id: "", url: $0, width: 0, height: 0) })
    
    static var MockedList: [Critique] {
        let title = "Title"
        let longTitle = "Long long title so it takes 2 lines lol wondonon qdwonqwdonqwonqwdonidqw nodqwnoi qwdnoidqwnoiqwdnoidqwnoiqw dnioqdwqdnwio qnowiddnoqw nowiqdwdnqoi wdnnqiowdnoi qwd"
        
        let path = Bundle.main.path(forResource: "index", ofType: "html")
        let string = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        
        return (0...10).compactMap({ Critique(id: "", title: (($0 % 2) == 1) ? title : longTitle, shortDescription: "short", descriptionHTML: string, author: .init(id: "", imageUrl: "https://shoptogether.s3.amazonaws.com/assets/shoptogethermodernlogo.png", name: "Michel", decription: "Oui"), media: medias, defaultMedia: medias.randomElement()!) })
    }
}
