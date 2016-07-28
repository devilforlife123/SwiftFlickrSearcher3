//
//  FlickrPhotoDownloader.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 26/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

private let _singletonInstance = FlickrPhotoDownloader()

public class FlickrPhotoDownloader{
    
    let imageOperations = NSOperationQueue()
    
    func cancelSetImageToImageView(imageView:UIImageView){
    
        for imageViewOperation in imageOperations.operations as! [FlickrPhotoDownloadOperation]{
            if imageViewOperation.imageView == imageView{
                imageViewOperation.imageView = nil 
            }
        }
    }
    
    public class func sharedInstance()->FlickrPhotoDownloader{
        return _singletonInstance
    }

    
    func setImageFromURLString(urlString:String,toImageView imageView:UIImageView){
        let cachedImage = FlickrPhotoDownloadOperation.cachedImageForURLString(urlString)
        
        if let unwrappedImage = cachedImage{
            imageView.image = unwrappedImage
        }else{
            let flickrDownloadOperation = FlickrPhotoDownloadOperation(urlString: urlString, imageView: imageView)
            imageOperations.addOperation(flickrDownloadOperation)
        }
        
    }
    
}