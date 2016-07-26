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
    
    weak var tableView:UITableView!
    let resultsController:NSFetchedResultsController
    let managedObjectContext = CoreDataStack.sharedInstance().mainContext()
    var downloader = FlickrDownloader()
    
    required init(favoritesOnly:Bool){
        
        let fetchRequest = NSFetchRequest(entityName: Photo.flk_className())
        
        if favoritesOnly{
            let predicate = NSPredicate(format: "%K == YES","isFavorite")
            fetchRequest.predicate = predicate
        }
        
        let sortByID = NSSortDescriptor(key:"photoID",ascending: false)
        fetchRequest.sortDescriptors = [sortByID]
        
        resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        reloadFRC()
        
        resultsController.delegate = self
    }
    
    private func reloadFRC(){
        do{
            try resultsController.performFetch()
        }catch let error as NSError{
            NSLog("Error:\(error)")
        }
    }
    
    //MARK:- UITableViewDataSource and UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (resultsController.sections?[section])?.numberOfObjects ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PhotoTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! PhotoTableViewCell
        
        //Cancel any previous Operations setting to this 
        
        downloader.cancelSetToImageView(cell.photoImageView)
        
        let photoAtIndex = resultsController.objectAtIndexPath(indexPath) as! Photo
        
        cell.titleLabel.text = photoAtIndex.title
        
        if let userName = photoAtIndex.owner.name{
            cell.userNameLabel.text = userName
        }else{
            cell.userNameLabel.text = photoAtIndex.owner.userID
        }
        
        if photoAtIndex.isFavorite{
            cell.favouriteIcon.tintColor = UIColor.redColor()
        }else{
            cell.favouriteIcon.tintColor = UIColor.clearColor()
        }
        
        downloader.setImageFromURLString(photoAtIndex.thumnailURLString, toImageView: cell.photoImageView!)
        
        return cell
    }
}