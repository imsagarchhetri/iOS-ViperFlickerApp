//
//  PhotoSearchPresenter.swift
//  FlickrViperTest
//
//  Created by Sagar on 8/6/17.
//  Copyright © 2017 Sagar. All rights reserved.
//


import UIKit

protocol PhotoSearchPresenterInput: PhotoViewControllerOutput, PhotoSearchInteractorOutput {
    
}

class PhotoSearchPresenter: PhotoSearchPresenterInput {
    
    var view: PhotoViewController!
    var interactor: PhotoSearchInteractorInput!
    var router: PhotoSearchRouterInput!
    
    
    //Presenter says interactor ViewController needs photos
    func fetchPhotos(_ searchtag: String, page: NSInteger) {
        
        
        if view.getTotalPhotoCount() == 0 {
            view.showWaitingView()
        }
        
        interactor.fetchAllPhotosFromDataManager(searchtag, page: page)
    }
    
    //Service return photos and interactor passes all data to prensenter which 
    //make view display them
    func providedPhotos(_ photos: [FlickrPhotoModel], totalPages: NSInteger) {
        self.view.hideWaitingView()
        self.view.displayFetchedPhotos(photos, totalPages: totalPages)
        
    }
    
    //Show error message from service
    func serviceError(_ error: NSError) {
        self.view.displayErrorView(defaultErrorMessage)
    }
    
    func gotoPhotoDetailScreen() {
        self.router.navigateToPhotoDetail()
    }
    
}
