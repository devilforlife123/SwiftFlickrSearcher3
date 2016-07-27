//
//  NSManagedObjectExtension.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 26/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObject{
   
    class func flk_newInContext(context:NSManagedObjectContext)->NSManagedObject?{
        
        let entityDescription = NSEntityDescription.entityForName(flk_className(), inManagedObjectContext: context)
        if let unwrappedDescription = entityDescription{
            let object = NSManagedObject(entity:unwrappedDescription,insertIntoManagedObjectContext: context)
            return object
        }
        
        return nil 
    }
    
}