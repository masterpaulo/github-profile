//
//  UserData+CoreDataClass.swift
//  github-profile
//
//  Created by John Paulo on 12/17/20.
//
//

import Foundation
import CoreData

@objc(UserData)
public class UserData: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(id, forKey: .id)
            try container.encode(login, forKey: .login)
            try container.encode(avatarURL, forKey: .avatarURL)
            try container.encode(type, forKey: .type)
            try container.encode(name, forKey: .name)
            try container.encode(company, forKey: .company)
            try container.encode(blog, forKey: .blog)
            try container.encode(followers, forKey: .followers)
            try container.encode(following, forKey: .following)
        } catch {
            print("error")
        }
    }

    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Commit", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try values.decode(Int16.self, forKey: .id)
            login = try values.decode(String.self, forKey: .login)
            avatarURL = try values.decode(String.self, forKey: .avatarURL)
            type = try values.decode(String.self, forKey: .type)
            name = try values.decode(String.self, forKey: .name)
            company = try values.decode(String.self, forKey: .company)
            blog = try values.decode(String.self, forKey: .blog)
            followers = try values.decode(Int16.self, forKey: .followers)
            following = try values.decode(Int16.self, forKey: .following)

        } catch {
            print ("error")
        }
    }

    enum CodingKeys : String, CodingKey {
        // Common properties for User List and Profile objects
        case login, id, type
        case avatarURL = "avatar_url"
        
        // Optional properties only found on User Profile objects
        case name, company, blog, followers, following
    }
}

// MARK: - Domain Data Functions

extension UserData {
    // Convert UserData to equivalent User object
    func asDomain() -> User {
        let encodedUserData = try! JSONEncoder().encode(self)
        let user = try! JSONDecoder().decode(User.self, from: encodedUserData)
        user.note = note
        return user
    }
    
    // Update properties based from a given User
    // assuming the passed User object contains the latest details
    func configure(with user: User) {
        // id = user.id // skip id since it's unique
        login = user.login
        avatarURL = user.avatarURL
        type = user.type.rawValue
        
        // Optional fields - only update properties if User's property exist
        if let name = user.name {
            self.name = name
        }
        if let company = user.company {
            self.company = company
        }
        if let blog = user.blog {
            self.blog = blog
        }
        if let followers = user.followers {
            self.followers = Int16(followers)
        }
        if let following = user.following {
            self.following = Int16(following)
        }
        if let note = user.note {
            self.setValue(note, forKey: "note")
        }
    }
}
