//
//  DataManagerTests.swift
//  github-profile-tests
//
//  Created by John Paulo on 12/18/20.
//

import XCTest
@testable import github_profile

class DataManagerTests: XCTestCase {

    var dataManager: DataManager!
    
    var user1: User {
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
    
    var user2: User {
        let user = User(
            id: 2,
            login: "user2",
            avatarURL: "https://avatar.sample.com./u/2",
            type: .user,
            
            // Optional properties
            name: "Ken Miller",
            company: "STC",
            blog: "",
            followers: 10,
            following: 10
        )
        user.note = "Sample Note"
        return user
    }
    
    var user3: User {
        let user = User(
            id: 3,
            login: "user3",
            avatarURL: "https://avatar.sample.com./u/3",
            type: .organization,
            
            // Optional properties
            name: "Shibata Inc.",
            company: "",
            blog: "",
            followers: 1700,
            following: 2
        )
        user.note = "Sample Note"
        return user
    }

    override func setUp() {
        super.setUp()
        dataManager = DataManager(persistentContainer: TestCoreDataContainer.getContainer())
    }
    
    override func tearDown() {
        super.tearDown()
        dataManager = nil
    }
    
    /// Add User to local storage
    func testAddUser() {
        // Add 1st user and reload list
        dataManager.addOrUpdate(user: user1)
        dataManager.loadSavedData()
        XCTAssertEqual(dataManager.userList.count, 1)
        guard let user = dataManager.userList.first else {
            XCTFail()
            return
        }
        
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
    }
    
    /// Add multiple User to local storage (one at a time)
    func testAddMultipleUser() {
        // Add 1st user and reload list
        dataManager.addOrUpdate(user: user1)
        dataManager.loadSavedData()
        XCTAssertEqual(dataManager.userList.count, 1)
        
        // Add 2nd user and do not reload list
        dataManager.addOrUpdate(user: user2)
        XCTAssertEqual(dataManager.userList.count, 1) // Should not be 2
        
        // Add 3rd user and reload list
        dataManager.addOrUpdate(user: user3)
        dataManager.loadSavedData()
        XCTAssertEqual(dataManager.userList.count, 3)
    }
    
    /// Add a list of User to local storage
    func testAddUsers() {
        dataManager.updateUserList(with: [user1, user2, user3])
        XCTAssertEqual(dataManager.userList.count, 3)
    }
    
    /// Reset list of Users
    func testResetUserList() {
        dataManager.updateUserList(with: [user1, user2, user3])
        
        // Check if list is correctly populated
        XCTAssertEqual(dataManager.userList.count, 3)
        
        // Check if list items are in correct position
        XCTAssertEqual(dataManager.userList.first?.id, 1)
        XCTAssertEqual(dataManager.userList.last?.id, 3)
        
        dataManager.setUserList(to: [user3, user2]) // Reset user list to have 2 items only
        
        // Check if list was reset
        XCTAssertEqual(dataManager.userList.count, 2)
        
        // Check if list items are in correct position
        XCTAssertEqual(dataManager.userList.first?.id, 3)
        XCTAssertEqual(dataManager.userList.last?.id, 2)
        
    }
    
    /// Get User success
    func testGetUser() {
        let id = user1.id
        dataManager.addOrUpdate(user: user1)
        let data = dataManager.getUserData(with: id)
        
        guard let userData = data else {
            XCTFail()
            return
        }
        
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
    
    
    func testUpdateUser() {
        dataManager.addOrUpdate(user: user1)
        
        let editUser1 = user1
        editUser1.name = "Emily Star" // Edit name
        editUser1.note = "Emily was here" // Edit note
        
        dataManager.addOrUpdate(user: editUser1)
        dataManager.loadSavedData()
        
        guard let user = dataManager.userList.first else {
            XCTFail()
            return
        }
        
        // Check all properties of user1 with the new updates
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.login, "user1")
        XCTAssertEqual(user.avatarURL, "https://avatar.sample.com./u/1")
        XCTAssertEqual(user.type, .user)
        XCTAssertEqual(user.name, "Emily Star")
        XCTAssertEqual(user.company, "Swiss Cottage")
        XCTAssertEqual(user.blog, "https://jasonmiller.com")
        XCTAssertEqual(user.followers, 100)
        XCTAssertEqual(user.following, 1)
        XCTAssertEqual(user.note, "Emily was here")
    }
    
    func testDeleteAllUsers() {
        dataManager.addOrUpdate(user: user1)
        let err = dataManager.deleteAllUsers()
        XCTAssertNil(err)
        
        dataManager.loadSavedData()
        XCTAssertEqual(dataManager.userList.count, 0)
    }
}
