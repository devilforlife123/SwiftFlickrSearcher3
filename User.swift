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

}
