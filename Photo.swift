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
    @NSManaged public var thumnailURLString:String
    @NSManaged public var photoID:String
    @NSManaged public var title:String
    @NSManaged public var owner:User
    @NSManaged public var isFavorite:Bool
    
    

}
