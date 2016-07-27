//
//  FlickrAPIComponents.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 26/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation

class FlickrAPIComponents{
    
    let BasePath = "/services/rest/"
    let urlComponents = NSURLComponents(string: "https://api.flickr.com")
    
    func urlWithParams(params:[NSURLQueryItem]?)->NSURL?{
        if let components = urlComponents{
            components.path = BasePath
            
            //Set the stock query Items
            
            let apiKeyQueryItem = NSURLQueryItem(name: FlickrParameterName.APIKey.rawValue, value: FlickrAuthCredential.APIKey.rawValue)
            let formatQueryItem = NSURLQueryItem(name: FlickrParameterName.Format.rawValue, value: FlickrParameterValue.Format.rawValue)
            let cleanJSONQueryItem = NSURLQueryItem(name: FlickrParameterName.CleanJSON.rawValue, value: FlickrParameterValue.CleanJSON.rawValue)
            var queryItems = [NSURLQueryItem]()
            queryItems += [apiKeyQueryItem,formatQueryItem,cleanJSONQueryItem]
            
            if let passedParams = params{
                for param in passedParams{
                    queryItems.append(param )
                }
            }
            components.queryItems = queryItems
            return components.URL
        }else{
            return nil 
        }
    }
}