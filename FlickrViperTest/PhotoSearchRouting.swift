//
//  PhotoSearchRouting.swift
//  FlickrViperTest
//
//  Created by Sagar on 8/6/17.
//  Copyright © 2017 Sagar. All rights reserved.
//

import UIKit

protocol PhotoSearchRouterInput: class {
    func navigateToPhotoDetail()
}

class PhotoSearchRouting : PhotoSearchRouterInput {
    
    weak var viewController: PhotoViewController!
    
    //MARK:- Navigation
    func navigateToPhotoDetail() {
        viewController.performSegue(withIdentifier: "ShowPhotoDetail", sender: nil)
    }
}
