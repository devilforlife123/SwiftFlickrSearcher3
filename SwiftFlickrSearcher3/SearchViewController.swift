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
    
    //IBOutlets
    @IBOutlet  weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    //Variables and constants
    
    let dataSource = PhotoDataSource(favoritesOnly: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FlickrSearcher3"
        
        dataSource.tableView = tableView
        tableView.dataSource = dataSource
        tableView.delegate = dataSource

    }
    
}
extension SearchViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if !searchBar.text!.isEmpty{
           //If the searchBar is not Empty
            //Create the controller that will do the searching
           let controller = FlickrAPIController()
            
            controller.fetchPhotosForText(searchBar.text!, completion: { (success, results) in
                if let unwrappedResult = results{
                    self.dataSource.deleteAllData()
                    FlickrJSONParser.parsePhotoListDictionary(unwrappedResult)
                    CoreDataStack.sharedInstance().saveMainContext()
                }
            })
            
        }
        
    }
    
}