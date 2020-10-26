//
//  User.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-16.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var imageUrl: String
    var name: String
    var decription: String
}

extension User {
    static var mockedUser: User {
        return .init(id: "", imageUrl: "https://shoptogether.s3.amazonaws.com/assets/shoptogethermodernlogo.png", name: "Michel", decription: "Oui")
    }
}
