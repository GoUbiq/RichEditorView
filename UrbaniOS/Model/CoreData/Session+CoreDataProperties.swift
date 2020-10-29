//
//  Session+CoreDataProperties.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-27.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var id: String?
    @NSManaged public var userId: String?
    @NSManaged public var userEmail: String?
    @NSManaged public var userImgUrl: URL?
    @NSManaged public var userFirstName: String?
    @NSManaged public var userLastName: String?
    @NSManaged public var userAmountSaved: String?
    @NSManaged public var userCredit: String?

}
