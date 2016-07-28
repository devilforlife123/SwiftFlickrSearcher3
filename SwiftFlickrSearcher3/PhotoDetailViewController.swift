//
//  PhotoDetailViewController.swift
//  SwiftFlickrSearcher3
//
//  Created by suraj poudel on 27/07/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

class PhotoDetailViewController:UIViewController{
    
    //MARK:- IBOutlets
    
    @IBOutlet var photoImageView:UIImageView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var userNameLabel:UILabel!
    @IBOutlet var userAvatarImageView:UIImageView!
    @IBOutlet var favoriteButton:UIButton!

    var downloader = FlickrPhotoDownloader.sharedInstance()
    var photo:Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAvatarImageView.layer.cornerRadius = CGRectGetWidth(userAvatarImageView.frame) / 2
        userAvatarImageView.layer.borderWidth = 1
        userAvatarImageView.layer.borderColor = UIColor.blackColor().CGColor
        
        if let unwrappedPhoto = photo{
            configureForPhoto(unwrappedPhoto)
        }
        
    }
    
    func configureForPhoto(aPhoto:Photo){
        titleLabel.text = aPhoto.title
        downloader.setImageFromURLString(aPhoto.fullURLString, toImageView: photoImageView)
        userNameLabel.text = aPhoto.owner.name ?? aPhoto.owner.userID
        
        if let iconString = aPhoto.owner.iconURLString{
            downloader.setImageFromURLString(iconString, toImageView: userAvatarImageView)
        }else{
            userAvatarImageView.image = UIImage(named: "rwdevcon-logo")
        }
        
        configureFavoriteButtonColorBasedOnPhoto(aPhoto)
    }
    
    func configureFavoriteButtonColorBasedOnPhoto(aPhoto:Photo){
        if aPhoto.isFavorite {
            favoriteButton.tintColor = UIColor.redColor()
        } else {
            favoriteButton.tintColor = UIColor.lightGrayColor()
        }
    }
    
    @IBAction func toggleFavoriteStatus(){
        if let unwrappedPhoto = photo{
            unwrappedPhoto.isFavorite = !unwrappedPhoto.isFavorite
            CoreDataStack.sharedInstance().saveMainContext()
            configureFavoriteButtonColorBasedOnPhoto(unwrappedPhoto)
        }
    }
}