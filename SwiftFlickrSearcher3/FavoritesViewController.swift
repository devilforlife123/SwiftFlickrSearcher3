//
//  FavoritesViewController.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 28/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController:UIViewController{
    
    //MARK:- IBOutlets
    @IBOutlet var tableView:UITableView!
    let dataSource = PhotoDataSource(favoritesOnly: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("favorites", comment: "title for favorites view controller")
        
        //Set up the data source and delegate.
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        dataSource.tableView = tableView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ShowDetail") {
            // pass data to next view
            let tappedCell = sender as! PhotoTableViewCell
            let detail = segue.destinationViewController as! PhotoDetailViewController
            detail.photo = dataSource.photoForCell(tappedCell)
        }
    }
    
    @IBAction func close(){
        dismissViewControllerAnimated(true, completion: nil)
    }
}