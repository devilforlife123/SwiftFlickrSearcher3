//
//  NSObjectExtension.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 21/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension NSObject{
    
    public class func flk_className()->String{
        let classString = NSStringFromClass(self)
        
        let pieces = classString.componentsSeparatedByString(".")
        
        if pieces.count == 2{
            return pieces[1]
        }else{
            return classString 
        }
    }
    
    public class func flk_fetchRequestWithPredicate(predicate:NSPredicate?)->NSFetchRequest{
        let fetchRequest = NSFetchRequest(entityName: self.flk_className())
        fetchRequest.predicate = predicate
        return fetchRequest
    }
}