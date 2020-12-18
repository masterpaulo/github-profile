//
//  TestCoreDataContainer.swift
//  github-profile-tests
//
//  Created by John Paulo on 12/18/20.
//

import CoreData

class TestCoreDataContainer {
    class func getContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "github_profile")

        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores(completionHandler: { _, error in
          if let error = error as NSError? {
            fatalError("Failed to load stores: \(error), \(error.userInfo)")
          }
        })
        return container
    }
}
