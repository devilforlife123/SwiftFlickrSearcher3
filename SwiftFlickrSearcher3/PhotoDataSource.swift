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
    var resultsController:NSFetchedResultsController!
    let managedObjectContext = CoreDataStack.sharedInstance().mainContext()
    
    //This is the downloader class that does all the downloading and adding downloadOperations in the operationQueue
    
    var downloader = FlickrPhotoDownloader()
    
    required init(favoritesOnly:Bool){
        
        
        let fetchRequest = NSFetchRequest(entityName:Photo.flk_className())
        
        if favoritesOnly{
            let predicate = NSPredicate(format: "%K == YES", "isFavorite")
            fetchRequest.predicate = predicate
        }
        
        let sortByID = NSSortDescriptor(key: "photoID", ascending: false)
        fetchRequest.sortDescriptors = [sortByID]
        
        //Initialize the resultsController 
        resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        reloadFRC()
        
        resultsController.delegate = self
        
    }
    
    //UITableViewDataSource , UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (resultsController.sections?[section])?.numberOfObjects ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PhotoTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! PhotoTableViewCell
        
        //Now need to do the act of filling up the gotten cell
        //Cancel any previous operations setting to this
        downloader.cancelSetToImageView(cell.photoImageView!)
        
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
        
        //Now need to set the imageView 
        downloader.setImageFromURLString(photoAtIndex.thumbnailURLString, toImageView: cell.photoImageView!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK:- NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                                    atIndexPath indexPath: NSIndexPath?,
                                                forChangeType type: NSFetchedResultsChangeType,
                                                              newIndexPath: NSIndexPath?) {
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
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    //MARK:- CoreData Functions
    
    func reloadFRC(){
        do{
            try resultsController.performFetch()
        }catch let error as NSError{
             NSLog("ERROR: \(error)")
        }
    }
    
    func deleteAllData(){
        let fetchRequest = NSFetchRequest(entityName: Photo.flk_className())
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            for managedObject in results{
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedObjectContext.deleteObject(managedObjectData)
            }
        }catch let error as NSError {
            print("Detele all data in \(Photo.flk_className()) error : \(error) \(error.userInfo)")
        }
    }
    
    
}