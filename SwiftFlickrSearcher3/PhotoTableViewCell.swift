//
//  PhotoTableViewCell.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 21/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit


class PhotoTableViewCell:UITableViewCell{
    
    //MARK:- IBOutlets
    
    @IBOutlet var photoImageView:UIImageView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var userNameLabel:UILabel!
    @IBOutlet var favoriteIcon:UIImageView!
    
    
    class func cellIdentifier()->String{
        print("THis is the cellIdentifier \(flk_className())")
        return flk_className()
    }
    
}