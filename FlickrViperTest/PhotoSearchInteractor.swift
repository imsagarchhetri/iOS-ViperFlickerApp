//
//  File.swift
//  FlickrViperTest
//
//  Created by Sagar on 8/6/17.
//  Copyright © 2017 Sagar. All rights reserved.
//


import Foundation

protocol PhotoSearchInteractorInput: class {
    func fetchAllPhotosFromDataManager(_ searchTag: String, page: NSInteger)
}

protocol PhotoSearchInteractorOutput: class {
    func providedPhotos(_ photos: [FlickrPhotoModel], totalPages: NSInteger)
    func serviceError(_ error: NSError)
}

class PhotoSearchInteractor: PhotoSearchInteractorInput {
    
    var APIDataManager: FlickrPhotoSearchProtocol!
    var presenter: PhotoSearchInteractorOutput!
    
    func fetchAllPhotosFromDataManager(_ searchTag: String, page: NSInteger) {
        APIDataManager.fetchPhotosForSearchText(searchText: searchTag, page: page) { (error, totalPages, flickrPhotos) in
            if let photos = flickrPhotos {
                self.presenter.providedPhotos(photos, totalPages: totalPages)
                print(photos)
            } else if let error = error {
                print(error)
                self.presenter.serviceError(error)
            }
        }
    }
    
}
