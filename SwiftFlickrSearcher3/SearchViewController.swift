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
    
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var tableView:UITableView!
    
    //MARK:- Constants and Variables
    
    private let dataSource = PhotoDataSource(favoritesOnly: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SwiftFlickrSearcher3"
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        dataSource.tableView = tableView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowDetail"){
            let tappedCell = sender as! PhotoTableViewCell
            let detail = segue.destinationViewController as! PhotoDetailViewController
            detail.photo = dataSource.photoForCell(tappedCell)
            
        }
    }
}
extension SearchViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty{
            let controller = FlickrAPIController()
            controller.fetchPhotosForTerm(searchBar.text!, flickrAPICompletion: { (success, resultsDictionary) in
                if let unwrappedResults = resultsDictionary{
                   FlickrJSONParser.parsePhotoListDictionary(unwrappedResults)
                    CoreDataStack.sharedInstance().saveMainContext()
                }
                
            })
            
        }
    }
}