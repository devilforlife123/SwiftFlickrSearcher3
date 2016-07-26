//
//  NSString.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 26/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation

extension NSString{
    
    class func flk_pathToDocumentsDirectory()->String{
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask,true).last!
    }
    
    public class func flk_createdDocumentsSubDirectory(subDirectoryName:String)->String{
        //Get the docs Directory
        let docs = flk_pathToDocumentsDirectory()
        //get the subDirectory
        let subDirectory = (docs as NSString).stringByAppendingPathComponent(subDirectoryName)
        flk_createDirectoryIfNeeded(subDirectory)
        return subDirectory
        
    }
    
    public class func flk_createDirectoryIfNeeded(subDirectory:String){
        if !NSFileManager.defaultManager().fileExistsAtPath(subDirectory){
            do{
                try NSFileManager.defaultManager().createDirectoryAtPath(subDirectory, withIntermediateDirectories: true, attributes: nil)
                
            }catch let error as NSError{
                NSLog("Error creating directory\(self): \(error)")
            }
        }
    }
}