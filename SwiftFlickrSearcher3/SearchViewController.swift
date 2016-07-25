//
//  SearchViewController.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 21/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit


class SearchViewController:UIViewController{
    
    //MARK:-IBOutlets and Variables
    
    @IBOutlet var tableView:UITableView!
    
    let dataSource = PhotoDataSource(favouritesOnly:false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FlickrSearcher3"
        
        dataSource.tableView = tableView
    }
    
}