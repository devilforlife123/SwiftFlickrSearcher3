//
//  PhotoDataSource.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 21/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class PhotoDataSource:NSObject,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate{
    
    private unowned var tableView:UITableView!
    
    required init(favouritesOnly:Bool){
        
        let fetchRequest = NSFetchRequest(entityName:Photo.className())
        
        if favouritesOnly{
            let predicate = NSFetchRequest("%K == YES","isFavorite")
            fetchRequest.predicate = predicate
        }
    }
}