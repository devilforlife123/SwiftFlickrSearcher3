//
//  CoreDataStack.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 26/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import CoreData


private let _singletonInstance = CoreDataStack()

public let ManagedObjectModelName = "FlickrSearcher3"
public let ManagedObjectModelExtension = "momd"

public class CoreDataStack{
    
    //MARK:- Variables and constants
    public var isTesting = false 
    var _managedObjectContext:NSManagedObjectContext?
    var _persistentStoreCoordinator:NSPersistentStoreCoordinator?
    var _managedObjectModel:NSManagedObjectModel?
    
    //MARK:- Functions and Methods
    
    public class func sharedInstance()->CoreDataStack{
        return _singletonInstance
    }
    
    public func mainContext()->NSManagedObjectContext{
        if _managedObjectContext == nil{
            _managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            _managedObjectContext!.persistentStoreCoordinator = self.coordinator()
        }
        return _managedObjectContext!
    }
    
    func coordinator()->NSPersistentStoreCoordinator{
        
        if _persistentStoreCoordinator == nil{
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model())
            var storeType = NSSQLiteStoreType
            var url:NSURL? = self.databaseFileURL()
            if self.isTesting{
                
                storeType = NSInMemoryStoreType
                url = nil
            }
            
            NSLog("Persistent store file Path: \(url?.path)")
            do{
                try _persistentStoreCoordinator!.addPersistentStoreWithType(storeType, configuration: nil, URL:url, options: [NSMigratePersistentStoresAutomaticallyOption:true,NSInferMappingModelAutomaticallyOption:true])
            }catch let error as NSError{
                NSLog("Error is ->\(error)")
            }
            
        }
        return _persistentStoreCoordinator!
    }
    
    func model()->NSManagedObjectModel{
        if _managedObjectModel == nil{
            let url = NSBundle.mainBundle().URLForResource(ManagedObjectModelName, withExtension: ManagedObjectModelExtension)
            _managedObjectModel = NSManagedObjectModel(contentsOfURL: url!)
        }
        return _managedObjectModel!
    }
    
    func saveMainContext(){
        do{
            try mainContext().save()
        }catch let error as NSError{
            assert(false, "ERROR SAVING CONTEXT: \(error)")
        }
    }
    
    
    func databaseFileURL()->NSURL{
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last! as NSURL
        let file = documentsDirectory.URLByAppendingPathComponent("FlickrSearcher3.sqlite")
        return file
    }
}