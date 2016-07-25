//
//  PhotoDataSource.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 21/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit


class PhotoDataSource:NSObject,UITableViewDataSource,UITableViewDelegate{
    
    
    //MARK:- Variables
    
    var tableView:UITableView!
    
    
    //MARK:- Initializer
    required init(favoritesOnly:Bool){
        
    }

    //MARK:- UITableViewDataSource and UITableViewDelegate methods 
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searches.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(PhotoTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! PhotoTableViewCell
        

        return cell
        
        
        
    }
}