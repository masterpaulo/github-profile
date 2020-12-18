//
//  User.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import Foundation
import CoreData
/* User List response data
{
  "login": "mojombo",
  "id": 1,
  "node_id": "MDQ6VXNlcjE=",
  "avatar_url": "https://avatars0.githubusercontent.com/u/1?v=4",
  "gravatar_id": "",
  "url": "https://api.github.com/users/mojombo",
  "html_url": "https://github.com/mojombo",
  "followers_url": "https://api.github.com/users/mojombo/followers",
  "following_url": "https://api.github.com/users/mojombo/following{/other_user}",
  "gists_url": "https://api.github.com/users/mojombo/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
  "organizations_url": "https://api.github.com/users/mojombo/orgs",
  "repos_url": "https://api.github.com/users/mojombo/repos",
  "events_url": "https://api.github.com/users/mojombo/events{/privacy}",
  "received_events_url": "https://api.github.com/users/mojombo/received_events",
  "type": "User",
  "site_admin": false
}
 */

/* User Profile response data
 {
   "login": "tawk",
   "id": 9743939,
   "node_id": "MDEyOk9yZ2FuaXphdGlvbjk3NDM5Mzk=",
   "avatar_url": "https://avatars0.githubusercontent.com/u/9743939?v=4",
   "gravatar_id": "",
   "url": "https://api.github.com/users/tawk",
   "html_url": "https://github.com/tawk",
   "followers_url": "https://api.github.com/users/tawk/followers",
   "following_url": "https://api.github.com/users/tawk/following{/other_user}",
   "gists_url": "https://api.github.com/users/tawk/gists{/gist_id}",
   "starred_url": "https://api.github.com/users/tawk/starred{/owner}{/repo}",
   "subscriptions_url": "https://api.github.com/users/tawk/subscriptions",
   "organizations_url": "https://api.github.com/users/tawk/orgs",
   "repos_url": "https://api.github.com/users/tawk/repos",
   "events_url": "https://api.github.com/users/tawk/events{/privacy}",
   "received_events_url": "https://api.github.com/users/tawk/received_events",
   "type": "Organization",
   "site_admin": false,
   "name": null,
   "company": null,
   "blog": "",
   "location": null,
   "email": null,
   "hireable": null,
   "bio": null,
   "twitter_username": null,
   "public_repos": 27,
   "public_gists": 0,
   "followers": 0,
   "following": 0,
   "created_at": "2014-11-14T12:23:56Z",
   "updated_at": "2016-06-02T16:06:17Z"
 }
 */

enum UserType: String, Codable {
    case user = "User"
    case organization = "Organization"
}


class User: Codable {
    let id: Int
    
    // Required properties
    var login: String
    var avatarURL: String
    var type: UserType
    
    // Optional properties
    var name: String?
    var company: String?
    var blog: String?
    var followers: Int?
    var following: Int?
    
    private enum CodingKeys : String, CodingKey {
        // Common properties for User List and Profile objects
        case login, id, type
        case avatarURL = "avatar_url"
        
        // Optional properties only found on User Profile objects
        case name, company, blog, followers, following
    }
    
    init(id: Int,
         login: String,
         avatarURL: String,
         type: UserType,
         name: String? = nil,
         company: String? = nil,
         blog: String? = nil,
         followers: Int? = nil,
         following: Int? = nil
    ) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
        self.type = type
        
        self.name = name
        self.company = company
        self.blog = blog
        self.followers = followers
        self.following = following
    }
    
    
    var note: String?
    
    var hasNote: Bool {
        return !(note?.isEmpty ?? true)
    }
}

// MARK: - Core Data Functions

extension User {
    // Conver User object to equivalent UserData
    func asCoreData(in context: NSManagedObjectContext) -> UserData {
        let userData = UserData(context: context)
        userData.id = Int16(id)
        userData.login = login
        userData.avatarURL = avatarURL
        userData.type = type.rawValue
        userData.name = name
        userData.company = company
        userData.blog = blog
        userData.followers = Int16(followers ?? 0)
        userData.following = Int16(following ?? 0)
        userData.note = note
        
        return userData
    }
    
    // Update properties based from a given UserData
    // assuming the passed UserData contains the latest details to copy
    func configuer(with userData: UserData) {
        login = userData.login
        avatarURL = userData.avatarURL
        type = userData.userType ?? .user
        if let name = userData.name {
            self.name = name
        }
        if let company = userData.company {
            self.company = company
        }
        if let blog = userData.blog {
            self.blog = blog
        }
        self.followers = Int(userData.followers)
        self.following = Int(userData.following)
        if let note = userData.note {
            self.note = note
        }
    }
}
