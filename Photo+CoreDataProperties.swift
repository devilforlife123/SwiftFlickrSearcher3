//
//  Photo+CoreDataProperties.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 25/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var fullURLString: String?
    @NSManaged var isFavorite: NSNumber?
    @NSManaged var photoID: String?
    @NSManaged var thumbnailURLString: String?
    @NSManaged var title: String?
    @NSManaged var has: User?

}
