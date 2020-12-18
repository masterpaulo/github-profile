//
//  DataManager.swift
//  github-profile
//
//  Created by John Paulo on 12/17/20.
//

import UIKit
import CoreData

final class DataManager {
    static let shared: DataManager = DataManager()
    
    var container: NSPersistentContainer!

    // MARK: - Shared Variables
    
    var userList = [User]()
    
    // MARK: - Computed Properties
    
    var udid: String { return UIDevice.current.identifierForVendor!.uuidString }
    
    
    // MARK: - init
    
    init() {
        // Create the persistent container and point to the xcdatamodeld - so matches the xcdatamodeld filename
        container = NSPersistentContainer(name: "github_profile")
        
        // load the database if it exists, if not create it.
        container.loadPersistentStores { storeDescription, error in
            // resolve conflict by using correct NSMergePolicy
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    
    init(persistentContainer: NSPersistentContainer) {
        container = persistentContainer
        
        // load the database if it exists, if not create it.
        container.loadPersistentStores { storeDescription, error in
            // resolve conflict by using correct NSMergePolicy
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    
    
    // MARK: - Methods
    
    
    // Load user list stored from DB
    func loadSavedData() {
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        let sort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            // fetch is performed on the NSManagedObjectContext
            let result = try container.viewContext.fetch(request)
            print("Got \(result.count) users")
            self.userList = result.map { $0.asDomain() }
            
        } catch {
            print("Fetch failed")
        }
    }
    
    // Save current context of DB
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                print ("Saved")
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func getUserData(with id: Int) -> UserData? {
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        let idPredicate = NSPredicate(format: "id == \(id)")
        request.predicate = idPredicate
        
        do {
            let result = try container.viewContext.fetch(request)
            return result.first
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return nil
        }
    }
    
    
    /// Add or update a User object to the DB and return the UserData instance
    @discardableResult
    func addOrUpdate(user: User) -> UserData {
        if let existingUserData = getUserData(with: user.id) {
            existingUserData.configure(with: user) // Copy (only) new values form User
            return existingUserData
        }
        else {
            let newUserData = add(user: user)
            return newUserData
        }
        
        // save data
    }
    /// Save or Update new Users to DB and overwrite current list. Returns the complete list of User
    @discardableResult
    func setUserList(to users: [User]) -> [User] {
        let newUserList = users.map { addOrUpdate(user: $0) }
        print("Updated user list with: \(newUserList.count)")
        userList = newUserList.map{ $0.asDomain() }
        return userList
        // save data
    }
    
    /// Save or Updatenew Users  to DB and append to current user list. Returns the complete list of User
    @discardableResult
    func updateUserList(with users: [User]) -> [User] {
        let newUserList = users.map { addOrUpdate(user: $0) }
        print("Updated user list with: \(newUserList.count)")
        userList.append(contentsOf: newUserList.map{ $0.asDomain() })
        return userList
        // save data
    }
    
    /// Delete all User from DB; Return error if unsuccesful
    @discardableResult
    func deleteAllUsers() -> Error? {
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let result = try container.viewContext.fetch(request)
            for obj in result {
                container.viewContext.delete(obj)
            }
            self.saveContext()
            self.userList = []
            return nil
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return error
        }
    }
    
    
    @discardableResult
    private func add(user: User) -> UserData {
        let userData = user.asCoreData(in: container.viewContext)
        
        return userData
    }
    
    @discardableResult
    private func add(users: [User]) -> [UserData] {
        let userDatas = users.map { $0.asCoreData(in: container.viewContext) }
        
        return userDatas
    }
}
