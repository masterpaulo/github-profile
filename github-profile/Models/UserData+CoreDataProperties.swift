//
//  UserData+CoreDataProperties.swift
//  github-profile
//
//  Created by John Paulo on 12/17/20.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var id: Int16
    @NSManaged public var login: String
    @NSManaged public var avatarURL: String
    @NSManaged public var type: String
    @NSManaged public var name: String?
    @NSManaged public var company: String?
    @NSManaged public var blog: String?
    @NSManaged public var followers: Int16
    @NSManaged public var following: Int16
    
    @NSManaged public var note: String?
    
    // MARK: - Computed Properties
    
    var userType: UserType? {
        return UserType(rawValue: type)
    }
}

extension UserData : Identifiable {

}
