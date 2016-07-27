//
//  FlickrPhotoDownloader.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 26/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

public class FlickrPhotoDownloader{
    
    //The downloader class has the downloadQueue which is an NSOperationQueue Object where you pile all the operations
    let downloadQueue = NSOperationQueue()
    
    init(){
        downloadQueue.maxConcurrentOperationCount = 5
    }
    
    func cancelSetToImageView(imageView:UIImageView){
        
        for imageOperation in downloadQueue.operations as! [FlickrDownloadOperation]{
            if imageOperation.imageView == imageView{
                imageOperation.imageView = nil 
            }
        }
    }
    
    //Set the ImageView from the URLString that we have gotten 
    
    func setImageFromURLString(urlString:String,toImageView imageView:UIImageView){
        
        let cachedImage = FlickrDownloadOperation.cachedImageForURLString(urlString)
        
        if let unwrappedImage = cachedImage{
            imageView.image = unwrappedImage
        }else{
            let imageDownloadOperation = FlickrDownloadOperation(urlString:urlString,imageView:imageView)
            downloadQueue.addOperation(imageDownloadOperation)
        }
    }
}