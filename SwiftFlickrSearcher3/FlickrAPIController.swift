//
//  FlickrAPIController.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 26/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

public class FlickrAPIController{
    
    public typealias FlickrAPICompletion = (success:Bool,resultsDictionary:[String:AnyObject]?)->()
    typealias InternalAPICompletion = (responseDict:[String:AnyObject]?,error:NSError?)->()
    
    func makeAPIRequest(httpMethod:HTTPMethod,params:[String:String],internalAPICompletion:InternalAPICompletion){
        
        var queryItems = [NSURLQueryItem]()
        let keys = Array(params.keys)
        let values = Array(params.values)
        for i in 0..<keys.count{
            let queryItem = NSURLQueryItem(name: keys[i], value: values[i])
            queryItems.append(queryItem)
        }
        
        let components = FlickrAPIComponents()
        if let url = components.urlWithParams(queryItems){
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = httpMethod.rawValue
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                if let unwrappedError = error{
                    NSLog("Error with API request:\(unwrappedError)")
                    internalAPICompletion(responseDict: nil, error: unwrappedError)
                }else{
                    do{
                        if let data = data , let dict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]{
                            internalAPICompletion(responseDict: dict, error: nil)
                        }
                    }catch let error as NSError{
                        print("JSON Error \(error)")
                    }
                }
            })
            task.resume()
        }
        
    }
    
    public func fetchPhotosForTerm(term:String,flickrAPICompletion:FlickrAPICompletion){
        
        let paramsDict = [
            FlickrParameterName.Method.rawValue : FlickrMethod.Search.rawValue,
            FlickrSearchParameterName.Tags.rawValue : term
        ]
        
        makeAPIRequest(HTTPMethod.GET, params: paramsDict) { (responseDict, error) in
            if let _ = error{
                self.fireCompletionOnMainQueueWithSuccess(false,result:nil,flickrAPICompletion:flickrAPICompletion)
            }else{
                self.fireCompletionOnMainQueueWithSuccess(true, result: responseDict, flickrAPICompletion: flickrAPICompletion)
            }
        }
        
    }
    
    private func fireCompletionOnMainQueueWithSuccess(success:Bool,result:[String:AnyObject]?,flickrAPICompletion:FlickrAPICompletion){
        
        if NSThread.currentThread() == NSThread.mainThread(){
            flickrAPICompletion(success: success, resultsDictionary: result)
        }else{
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                flickrAPICompletion(success: success, resultsDictionary: result)
            })
        }
        
    }
    
}
