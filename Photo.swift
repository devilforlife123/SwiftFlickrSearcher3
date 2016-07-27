//
//  Photo.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 25/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import CoreData


public class Photo: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    @NSManaged public var fullURLString:String
    @NSManaged public var thumbnailURLString:String
    @NSManaged public var photoID:String
    @NSManaged public var title:String
    @NSManaged public var owner:User
    @NSManaged public var isFavorite:Bool
    
    
    class func photoInContextOrNew(context:NSManagedObjectContext,photoID:String)->Photo{
        let predicate = NSPredicate(format: "photoID == \(photoID)")
        let fetchRequest = flk_fetchRequestWithPredicate(predicate)
        var results:[Photo]?
        do{
            results = try context.executeFetchRequest(fetchRequest) as? [Photo]
        }catch let error as NSError{
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        if let photo = results?.first{
            return photo
        }
        
        //Did not find anything then we need to create new
        let created = flk_newInContext(context) as! Photo
        created.photoID = photoID
        return created 
        
    }
    

}
