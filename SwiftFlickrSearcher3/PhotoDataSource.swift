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
    
    let resultsController:NSFetchedResultsController
    let managedObjectConext:NSManagedObjectContext = CoreDataStack.sharedInstance().mainContext()
    let downloader = FlickrPhotoDownloader()
    var tableView:UITableView!
    
    required init(favoritesOnly:Bool){
        let fetchRequest = NSFetchRequest(entityName: Photo.flk_className())
        
        if favoritesOnly{
            let predicate = NSPredicate(format: "%K == YES", "favorites")
            fetchRequest.predicate = predicate
        }
        
        let sortByID = NSSortDescriptor(key: "photoID", ascending: false)
        fetchRequest.sortDescriptors = [sortByID]
        
        //Initialize the object resultsController
        
        resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectConext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        reloadFRC()
        resultsController.delegate = self
        
    }
    
    func reloadFRC(){
        do{
            try resultsController.performFetch()
        }catch let error as NSError{
            NSLog("ERROR: \(error)")
        }
    }
    
    
    func photoForCell(cell:PhotoTableViewCell)->Photo{
        let indexPath = tableView.indexPathForCell(cell)
        return resultsController.objectAtIndexPath(indexPath!) as! Photo
    }
    
    //MARK:- UITableViewDelegate & UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(PhotoTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! PhotoTableViewCell
        
        downloader.cancelSetImageToImageView(cell.photoImageView)
        
        let photoAtIndex = resultsController.objectAtIndexPath(indexPath) as! Photo
        
        cell.titleLabel!.text = photoAtIndex.title
        
        if let username = photoAtIndex.owner.name {
            cell.userNameLabel.text = username
        } else {
            cell.userNameLabel.text = photoAtIndex.owner.userID
        }
        
        if photoAtIndex.isFavorite {
            cell.favoriteIcon.tintColor = UIColor.redColor()
        } else {
            cell.favoriteIcon.tintColor = UIColor.clearColor()
        }
        
        downloader.setImageFromURLString(photoAtIndex.thumbnailURLString, toImageView: cell.photoImageView)
        
        
        
        return cell 
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    //MARK:- NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
         tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
}