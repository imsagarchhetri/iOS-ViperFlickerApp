//
//  FlickrPhotoModel.swift
//  FlickrViperTest
//
//  Created by Sagar on 8/6/17.
//  Copyright © 2017 Sagar. All rights reserved.
//

import Foundation

struct FlickrPhotoModel {
    let photoId : String
    let farm : Int
    let server: String
    let title: String
    let secret: String
    
    var photoUrl: NSURL {
       return flickrImageURL()
    }
    
    var largePhotoURL: NSURL {
        return flickrImageURL(size: "b")
    }
    
    func flickrImageURL(size: String = "m") -> NSURL {
        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_\(size).jpg")!
    }
}
