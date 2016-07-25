//
//  Flickr.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 21/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation


class FlickrPhoto{
    
    let photoID:String
    let title:String
    private let farm:Int
    private let server:String
    private let secret:String
    
    init(photoID:String,title:String,farm:Int,server:String,secret:String){
        self.photoID = photoID
        self.title = title
        self.farm = farm
        self.server = server
        self.secret = secret
    }
    
}


struct FlickrSearchResults{
    var searchString:String
    var flickrPhoto:[FlickrPhoto]
}

class Flickr{
    
    typealias SearchCompletionClosure = (results:FlickrSearchResults?,error:NSError?)->()
    
    func search(searchTerm:String,completion:SearchCompletionClosure){
        
    }
}