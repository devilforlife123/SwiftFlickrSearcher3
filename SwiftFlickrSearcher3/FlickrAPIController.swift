//
//  FlickrAPIController.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 26/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation

public class FlickrAPIController:NSObject{
    
    public typealias FlickrAPICompletion = (success:Bool,result:NSDictionary?)->()
    public typealias InternalAPICompletion = (responseDict:NSDictionary?,error:NSError?)->()
    
    
    func makeAPIRequest(httpMethod:HTTPMethod,params:[String:String],completion:InternalAPICompletion){
        //Now we need to construct a queryItem
        
        var queryItems = [NSURLQueryItem]()
        let allKeys = Array(params.keys)
        let allValues = Array(params.values)
        for i in 0..<allKeys.count{
            let queryItem = NSURLQueryItem(name: allKeys[i],value: allValues[i])
            queryItems.append(queryItem)
        }
        
        let components = FlickrAPIComponents()
        
        
    }
    public func fetchPhotosForText(text:String,completion:FlickrAPICompletion)  {
        //Make the Dict of the parameter
        let paramsDict = [
            FlickrParameterName.Method.rawValue : FlickrMethod.Search.rawValue,
            FlickrSearchParameterName.Tags.rawValue : text
        ]
        
        //Call the MakeAPIRequest Method With the completion Block
        makeAPIRequest(HTTPMethod.GET, params: paramsDict) { (responseDict, error) in
            if let _ = error{
                self.fireCompletionOnMainQueueWithSuccess(false,result:nil,completion:completion)
            }else{
                self.fireCompletionOnMainQueueWithSuccess(true,result:responseDict,completion:completion)
            }
        }
    
    }
    
    func fireCompletionOnMainQueueWithSuccess(success:Bool,result:NSDictionary?,completion:FlickrAPICompletion){
        //See if the currentThread is the mainThread
        if (NSThread.currentThread() == NSThread.mainThread()){
            completion(success: success, result: result)
        }else{
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                completion(success: success, result: result)
            })
        }
    }
    
    
}