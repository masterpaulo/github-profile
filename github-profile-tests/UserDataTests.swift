//
//  UserDataTests.swift
//  github-profile-tests
//
//  Created by John Paulo on 12/18/20.
//

import XCTest
import CoreData
@testable import github_profile

class UserDataTests: XCTestCase {
    
    let container = TestCoreDataContainer.getContainer()
    
    // UserData with complete properties
    lazy var sampeleUserData: UserData = {
        let userData = UserData(context: self.container.viewContext)
        userData.id = 0
        userData.login = "user0"
        userData.avatarURL = "https://avatar.sample.com./u/0"
        userData.type = "User"
        userData.name = "Michael Jackson"
        userData.company = "Bear Brand"
        userData.blog = ""
        userData.followers = 0
        userData.following = 500
        
        // userData.note = "No note"  // This is intentional
        
        return userData
    }()
    
    // User with basic required properties
    // Read-only
    var user1: User {
        return User(
            id: 1,
            login: "user1",
            avatarURL: "https://avatar.sample.com./u/1",
            type: .user
        )
    }
    
    // User with complete optional properties... including a note
    // Read-only
    var user2: User {
        let user = User(
            id: 2,
            login: "user2",
            avatarURL: "https://avatar.sample.com./u/2",
            type: .user,
            
            // Optional properties
            name: "Jason Miller",
            company: "Swiss Cottage",
            blog: "https://jasonmiller.com",
            followers: 100,
            following: 1
        )
        user.note = "Sample Note"
        return user
    }
    
    /// Configure UserData with User properties
    func testConfigureWithUser() throws {
        let userData = sampeleUserData
        
        // Check initial properties of UserData
        XCTAssertEqual(userData.id, 0)
        XCTAssertEqual(userData.login, "user0")
        XCTAssertEqual(userData.avatarURL, "https://avatar.sample.com./u/0")
        XCTAssertEqual(userData.type, "User")
        XCTAssertEqual(userData.name, "Michael Jackson")
        XCTAssertEqual(userData.company, "Bear Brand")
        XCTAssertEqual(userData.blog, "")
        XCTAssertEqual(userData.followers, 0)
        XCTAssertEqual(userData.following, 500)
        XCTAssertNil(userData.note)
        
        // Configure UserData with User properties
        userData.configure(with: user2)
        
        // Should reflect changes from all properties of User
        XCTAssertEqual(userData.id, 0)
        XCTAssertEqual(userData.login, "user2")
        XCTAssertEqual(userData.avatarURL, "https://avatar.sample.com./u/2")
        XCTAssertEqual(userData.type, "User")
        XCTAssertEqual(userData.name, "Jason Miller")
        XCTAssertEqual(userData.company, "Swiss Cottage")
        XCTAssertEqual(userData.blog, "https://jasonmiller.com")
        XCTAssertEqual(userData.followers, 100)
        XCTAssertEqual(userData.following, 1)
        XCTAssertEqual(userData.note, "Sample Note")
        
    }
    
    /// Configure UserData with User properties and should not overwrite if new value is nil
    func testConfigureWithUserNoOverwrite() throws {
        let userData = sampeleUserData
        
        // Check initial properties of UserData
        XCTAssertEqual(userData.id, 0)
        XCTAssertEqual(userData.login, "user0")
        XCTAssertEqual(userData.avatarURL, "https://avatar.sample.com./u/0")
        XCTAssertEqual(userData.type, "User")
        XCTAssertEqual(userData.name, "Michael Jackson")
        XCTAssertEqual(userData.company, "Bear Brand")
        XCTAssertEqual(userData.blog, "")
        XCTAssertEqual(userData.followers, 0)
        XCTAssertEqual(userData.following, 500)
        XCTAssertNil(userData.note)
        
        userData.configure(with: user1) // user1 has nil properties
        
        // Should reflect changes from all non-nil properties of User
        XCTAssertEqual(userData.id, 0)
        XCTAssertEqual(userData.login, "user1")
        XCTAssertEqual(userData.avatarURL, "https://avatar.sample.com./u/1")
        XCTAssertEqual(userData.type, "User")
        
        // Should not overwrite existing value from nil properties of User
        XCTAssertEqual(userData.name, "Michael Jackson")
        XCTAssertEqual(userData.company, "Bear Brand")
        XCTAssertEqual(userData.blog, "")
        XCTAssertEqual(userData.followers, 0)
        XCTAssertEqual(userData.following, 500)
        XCTAssertNil(userData.note)
        
    }
    
    /// Convert UserData to User object
    func testConvertToDomain() throws {
        let userData = sampeleUserData
        let user = userData.asDomain()
        
        XCTAssertEqual(user.id, 0)
        XCTAssertEqual(user.login, "user0")
        XCTAssertEqual(user.avatarURL, "https://avatar.sample.com./u/0")
        XCTAssertEqual(user.type, .user)
        XCTAssertEqual(user.name, "Michael Jackson")
        XCTAssertEqual(user.company, "Bear Brand")
        XCTAssertEqual(user.blog, "")
        XCTAssertEqual(user.followers, 0)
        XCTAssertEqual(user.following, 500)
    }


}
