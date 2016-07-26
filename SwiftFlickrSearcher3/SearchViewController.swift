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
    
    //MARK:- IBOutlets
    @IBOutlet var searchBar:UISearchBar!
    @IBOutlet var tableView:UITableView!
    
    let dataSource = PhotoDataSource(favoritesOnly: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FlickrSearcher3"
        
        dataSource.tableView = tableView
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
}
extension SearchViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty{
            var controller = FlickrAPIController()
            
        }
    }
}