//
//  FlickrJSONParser.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 26/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

public class FlickrJSONParser{
    
    public class func isResponseOK(photoListDict:[String:AnyObject])->Bool{
        if let status = photoListDict[FlickrReturnDataJSONKeys.Status.rawValue] as? String{
            if status == "ok"{
                return true
            }
        }
        return false
    }
    
    public class func parsePhotoListDictionary(photoListDict:[String:AnyObject])->[Photo]?{
        
        if !isResponseOK(photoListDict){
            return nil
        }
        
        if let unwrappedPhotoContainer = photoListDict[FlickrReturnDataJSONKeys.PhotoEnclosingDict.rawValue] as? [String:AnyObject]{
            if let unwrappedPhotos = unwrappedPhotoContainer[FlickrReturnDataJSONKeys.ListOfPhotos.rawValue] as? [[String:AnyObject]]{
                
                var photos = [Photo]()
                photos = unwrappedPhotos.map({parseIndividualDictionary($0)})
                return photos
            }
        }
        return nil
    }
    
    public class func parseIndividualDictionary(photoDict:[String:AnyObject])->Photo{
        
        let farm = photoDict[FlickrPhotoDataJSONKeys.Farm.rawValue]! as! Int
        let server = photoDict[FlickrPhotoDataJSONKeys.Server.rawValue]! as! String
        let photoID = photoDict[FlickrPhotoDataJSONKeys.ID.rawValue]! as! String
        let secret = photoDict[FlickrPhotoDataJSONKeys.Secret.rawValue]! as! String
        let userID = photoDict[FlickrPhotoDataJSONKeys.Owner.rawValue]! as! String
        
        let fullURL = "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret).jpg"
        let thumbURL = "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(FlickrPhotoSize.Thumbnail.rawValue).jpg"
        
        let mainContext = CoreDataStack.sharedInstance().mainContext()
        
        let photo = Photo.photoInContextOrNew(mainContext, photoID: photoID)
        photo.fullURLString = fullURL
        photo.thumbnailURLString = thumbURL
        photo.photoID = photoID
        photo.title = photoDict[FlickrPhotoDataJSONKeys.Title.rawValue]! as! String
        
        let user = User.userInContextOrNew(mainContext, userID: userID)
        user.userID = userID
        photo.owner = user
        
        return photo
    }
    
}