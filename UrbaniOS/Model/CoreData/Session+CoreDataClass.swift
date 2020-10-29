//
//  Session+CoreDataClass.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-27.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import UIKit
import CoreData


public class Session: NSManagedObject {
    @discardableResult
    class func createNewEntryWith(id: String, userId: String, userEmail: String?, firstName: String?, lastName: String?, userImage: URL?) -> Session {
        return Session(id: id, userId: userId, userEmail: userEmail, firstName: firstName, lastName: lastName, userImage: userImage)
    }
    
    private convenience init(id: String, userId: String, userEmail: String?, firstName: String?, lastName: String?, userImage: URL? = nil) {
        guard let entity = NSEntityDescription.entity(forEntityName: Session.entity().name!, in: mainContext) else { fatalError()  }
        
        self.init(entity: entity, insertInto: mainContext)
        
        self.id = id
        self.userId = userId
        self.userEmail = userEmail
        self.userImgUrl = userImage
        self.userFirstName = firstName
        self.userLastName = lastName
    }
    
    var isProfileComplete: Bool {
        return !((self.userFirstName ?? "").isEmpty || (self.userLastName ?? "").isEmpty)
    }
    
    var currentUser: User? {
        guard let userId = self.userId else { return nil }
        return nil
//        return User(id: userId,
//                    firstName: self.userFirstName,
//                    lastName: self.userLastName,
//                    imageUrl: self.userImgUrl?.absoluteString,
//                    email: self.userEmail)
    }
}
