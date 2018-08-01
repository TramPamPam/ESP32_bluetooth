//
//  CoreDataStack.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import Foundation
import CoreData
import zlib

protocol CoreDataStack {
    var persistentContainer: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
    func saveContext()
    func clearDataBase()
}

final class CoreDataStackImplementation: CoreDataStack {
    
    static let shared = CoreDataStackImplementation()
    
    private var applicationSupportFolder: URL {
        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!
        return URL(fileURLWithPath: path)
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Zori")
        
        let destinationURL = applicationSupportFolder.appendingPathComponent("Zori.sqlite")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            }
            
            container.viewContext.mergePolicy = MergePolicy.custom()
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func clearDataBase() {
       
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
    //    static let relativeObject = CodingUserInfoKey(rawValue: "relativeObject")
    //    static let hasLocalFiles = CodingUserInfoKey(rawValue: "hasLocalFiles")
}
