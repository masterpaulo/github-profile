//
//  UserTests.swift
//  github-profile-tests
//
//  Created by John Paulo on 12/18/20.
//

import XCTest
@testable import github_profile

class UserTests: XCTestCase {
    
    let container = TestCoreDataContainer.getContainer()
    
    // UserData with complete properties
    var sampeleUserData: UserData {
        let userData = UserData(context: container.viewContext)
        userData.id = 0
        userData.login = "user0"
        userData.avatarURL = "https://avatar.sample.com./u/0"
        userData.type = "User"
        userData.name = "Michael Jackson"
        userData.company = "Bear Brand"
        userData.blog = ""
        userData.followers = 0
        userData.following = 500
        userData.note = "I have a note"
        return userData
    }
    
    var user: User {
        let user = User(
            id: 1,
            login: "user1",
            avatarURL: "https://avatar.sample.com./u/1",
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
    
    // MARK: - Decoding Scenarios
    
    /// Decoding valid  mock json response of User list  data from "users.json" file
    func testDecodeUserListFromJSON() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.path(forResource: "users", ofType: "json") else {
            fatalError("Can't find users.json file")
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let userList = try JSONDecoder().decode([User].self, from: data)
        
        XCTAssertEqual(userList.count, 5)
        
        let user1 = userList.first
        
        XCTAssertEqual(user1?.id, 1)
        XCTAssertEqual(user1?.login, "mojombo")
        XCTAssertEqual(user1?.note, nil)
    }
    
    /// Decoding valid mock json response of User data from "users-tawk.json" file
    func testDecodeUserFromJSON() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.path(forResource: "users-tawk", ofType: "json") else {
            fatalError("Can't find users.json file")
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let user = try JSONDecoder().decode(User.self, from: data)
        
        // Validate properties
        XCTAssertEqual(user.id, 9743939)
        XCTAssertEqual(user.login, "tawk")
        XCTAssertEqual(user.note, nil)
        XCTAssertEqual(user.type, UserType.organization)
        
        
    }
    
    /// Decoding invalid mock json response of User data from "users-invalid.json" file
    func testDecodeUserFromInvalidJSON() {
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.path(forResource: "users", ofType: "json") else {
            fatalError("Can't find users.json file")
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            _ = try JSONDecoder().decode(User.self, from: data) // Should fail becuase id parameter type is String instead of Int (Number)
            
            // Fail test if JSON was successfuly decoded
            XCTFail()
        }
        catch {
            XCTAssertNotNil(error)
        }
        
    }
    
    // MARK: - Custom Methods
    
    /// Configure User with UserData properties and should not overwrite if new value is nil
    func testConfigureWithUserData() {
        let userData = sampeleUserData
        let user = self.user
        
        // Check initial property values of User object
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.login, "user1")
        XCTAssertEqual(user.avatarURL, "https://avatar.sample.com./u/1")
        XCTAssertEqual(user.type, .user)
        XCTAssertEqual(user.name, "Jason Miller")
        XCTAssertEqual(user.company, "Swiss Cottage")
        XCTAssertEqual(user.blog, "https://jasonmiller.com")
        XCTAssertEqual(user.followers, 100)
        XCTAssertEqual(user.following, 1)
        XCTAssertEqual(user.note, "Sample Note")
        
        user.configuer(with: userData)
        
        // user id cannot be overwritten
        XCTAssertEqual(user.id, 1)
        
        // Should reflect changes from all properties of User
        XCTAssertEqual(user.login, "user0")
        XCTAssertEqual(user.avatarURL, "https://avatar.sample.com./u/0")
        XCTAssertEqual(user.type, .user)
        XCTAssertEqual(user.name, "Michael Jackson")
        XCTAssertEqual(user.company, "Bear Brand")
        XCTAssertEqual(user.blog, "")
        XCTAssertEqual(user.followers, 0)
        XCTAssertEqual(user.following, 500)
        XCTAssertEqual(userData.note, "I have a note")
        
    }
    
    /// Convert UserData to User object
    func testConvertToDomain() throws {
        let userData = user.asCoreData(in: container.viewContext)
        
        XCTAssertEqual(userData.id, 1)
        XCTAssertEqual(userData.login, "user1")
        XCTAssertEqual(userData.avatarURL, "https://avatar.sample.com./u/1")
        XCTAssertEqual(userData.type, UserType.user.rawValue)
        XCTAssertEqual(userData.name, "Jason Miller")
        XCTAssertEqual(userData.company, "Swiss Cottage")
        XCTAssertEqual(userData.blog, "https://jasonmiller.com")
        XCTAssertEqual(userData.followers, 100)
        XCTAssertEqual(userData.following, 1)
        XCTAssertEqual(userData.note, "Sample Note")
    }
    
}
