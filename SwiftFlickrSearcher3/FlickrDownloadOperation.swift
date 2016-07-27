//
//  FlickrDownloadOperation.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 27/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

class FlickrDownloadOperation:NSOperation{
    
    var imageView:UIImageView?
    var urlString:String?
    
    init(urlString inUrlString:String,imageView inImageView:UIImageView){
        self.urlString = inUrlString
        self.imageView = inImageView
    }
    
    override func main() {
        autoreleasepool { 
            let downloadURL = NSURL(string:self.urlString!)!
            let filePath = FlickrDownloadOperation.downloadDirectoryPathForURLString(self.urlString!)
            let imageData = NSData(contentsOfURL:downloadURL)
            if let unwrappedData = imageData{
                let image = UIImage(data: unwrappedData)
                if let unwrappedImage = image{
                    self.setImageToImageView(unwrappedImage,imageView:self.imageView)
                }
                
                //Save the Data Automatically
                unwrappedData.writeToFile(filePath, atomically: false)
            }
            
        }
    }
    
    
    func setImageToImageView(image:UIImage,imageView:UIImageView?){
        NSOperationQueue.mainQueue().addOperationWithBlock { 
            if let unwrappedImageView = imageView{
                unwrappedImageView.image = image
            }
        }
    }
    
    class func cachedImageForURLString(urlString:String)->UIImage?{
        //get the filePath
        let filePath = downloadDirectoryPathForURLString(urlString)
        //Get the imageData 
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
        let originalPath = (urlString as NSString).substringFromIndex(serverRange.location + serverRange.length)
        let underscored = pathWithUnderscores(originalPath)
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