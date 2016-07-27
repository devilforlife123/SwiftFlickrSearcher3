//
//  User.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 25/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import CoreData

public class User: NSManagedObject {

    @NSManaged public var userID:String
    public var name:String?
    public var iconURLString:String?
    
    
// Insert code here to add functionality to your managed object subclass

    class func userInContextOrNew(context:NSManagedObjectContext,userID:String)->User{
        let predicate = NSPredicate(format: "userID == [c]'\(userID)'")
        let fetchRequest = flk_fetchRequestWithPredicate(predicate)
        var results:[User]?
        
        do{
            results = try context.executeFetchRequest(fetchRequest) as? [User]
        }catch let error as NSError{
            NSLog("Error encountered \(error)")
        }
        
        if let unwrappedResults = results{
            if let user = unwrappedResults.first{
                return user
            }
        }
        
        
        let created = flk_newInContext(context) as! User
        created.userID = userID
        return created 
    }
}
