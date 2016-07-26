//
//  FlickrPhotoDownloader.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 26/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

private let _singletonInstance = FlickrDownloader()

public class FlickrDownloader{
    
    let downloadQueue = NSOperationQueue()
    
    init(){
        downloadQueue.maxConcurrentOperationCount = 5
    }
    
    public class func sharedInstance()->FlickrDownloader{
        return _singletonInstance
    }
    
    
    func cancelSetToImageView(imageView:UIImageView){
        let imageViewOperations = downloadQueue.operations as! [FlickrDownloadOperation]
        for imageViewOperation in imageViewOperations{
            //If imageView Corresponding with the operation is equal to the passed ImageView
            if imageViewOperation.imageView == imageView{
                imageViewOperation.imageView = nil
            }
        }
    }
    
    func setImageFromURLString(urlString:String,toImageView imageView:UIImageView){
        
        //Get the cachedImage From the DownloadOperation Class
        if let cachedImage = FlickrDownloadOperation.cachedImageForURLString(urlString){
            //If the image is Cached in the directory
            imageView.image = cachedImage
        }else{
            //Create an FlickrDownloadOperation with urlString and imageView
            let downloadOperation = FlickrDownloadOperation(urlString:urlString,imageView: imageView)
            //add the download in the operationQueue
            downloadQueue.addOperation(downloadOperation)
        }
    }

}

private class FlickrDownloadOperation:NSOperation{
    
    var imageView:UIImageView?
    var urlString:String?
    
    init(urlString inUrlString:String,imageView inImageView:UIImageView){
        self.imageView = inImageView
        self.urlString = inUrlString
    }
    
    class func cachedImageForURLString(urlString:String)->UIImage?{
        let filePath = downloadDirectoryPathForURLString(urlString)
        
        let imageData = NSData(contentsOfFile: filePath)
        if let unwrappedData = imageData{
            let image = UIImage(data: unwrappedData)
            if let unwrappedImage = image{
                return unwrappedImage
            }
        }
        return nil
    }
    
    class func downloadDirectoryPathForURLString(urlString:String)->String{
        let serverRange = (urlString as NSString).rangeOfString("flickr.com/")
        let originalPath = (urlString as NSString).substringFromIndex(serverRange.length + serverRange.location)
        
        let underscored = pathWithUnderscores(originalPath as String)
        let filePath = (pathToPhotoDownloadDirectory() as NSString).stringByAppendingPathComponent(underscored)
        return filePath
        
    }
    
    class func pathWithUnderscores(originalPath:String)->String{
        
        return originalPath.stringByReplacingOccurrencesOfString("/", withString: "_")
    }
    
    class func pathToPhotoDownloadDirectory()->String{
        let downloadsPath = NSString.flk_createdDocumentsSubDirectory("photoDownloads")
        return downloadsPath
    }
}