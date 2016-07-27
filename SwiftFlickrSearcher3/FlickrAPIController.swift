//
//  FlickrAPIController.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 26/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation

public class FlickrAPIController:NSObject{
    
    public typealias FlickrAPICompletion = (success:Bool,results:[String:AnyObject]?)->()
    public typealias InternalAPICompletion = (responseDict:[String:AnyObject]?,error:NSError?)->()

    
    func makeAPIRequest(httpMethod:HTTPMethod,params:[String:String],completion:InternalAPICompletion){
        //This we will get back is an optional ResponseDict and Optional Error
        //Now we need to create query Items that helps in creating searching URL
        var queryItems = [NSURLQueryItem]()
        let allKeys = Array(params.keys)
        let allValues = Array(params.values)
        
        for i in 0..<allKeys.count{
            let queryItem = NSURLQueryItem(name: allKeys[i], value: allValues[i])
            queryItems.append(queryItem)
        }
        
        //Create another model called FlickrAPIComponents
        let components = FlickrAPIComponents()
        if let url = components.urlWithParams(queryItems){
            let request = NSMutableURLRequest(URL:url)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                if let unwrappedError = error{
                    NSLog("Error with API Request : \(unwrappedError)")
                }else{
                    do{
                        if let data = data , let dict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]{
                            completion(responseDict: dict, error: nil)
                        }
                        
                    }catch let error as NSError{
                        print("JSON Error \(error)")
                    }
                }
            })
            task.resume()
            
            
        }else{
            print("URL Fail!")
        }
        
    }
    
    
    public func fetchPhotosForText(text:String,completion:FlickrAPICompletion){
        
        let paramsDict = [
            FlickrParameterName.Method.rawValue : FlickrMethod.Search.rawValue,
            FlickrSearchParameterName.Tags.rawValue : text
        ]
        
        makeAPIRequest(HTTPMethod.GET, params: paramsDict) { (responseDict, error) in
            if let _ = error{
                self.fireCompletionOnMainQueueWithSuccess(false,result:nil,completion:completion)
            }else{
                self.fireCompletionOnMainQueueWithSuccess(true,result:responseDict,completion:completion)
            }
        }
    }
    
    
    private func fireCompletionOnMainQueueWithSuccess(success:Bool,result:[String:AnyObject]?,completion:FlickrAPICompletion){
        if(NSThread.currentThread() == NSThread.mainThread()){
            completion(success: success, results: result)
        }else{
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                completion(success: success, results: result)
            })
        }
    }
    
    
}