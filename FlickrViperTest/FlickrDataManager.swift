//
//  FlickrDataManager.swift
//  FlickrViperTest
//
//  Created by Sagar on 8/6/17.
//  Copyright © 2017 Sagar. All rights reserved.
//

import Foundation
import SDWebImage

protocol FlickrPhotoSearchProtocol: class {
    func fetchPhotosForSearchText(searchText: String, page: NSInteger, closure: @escaping (NSError?, NSInteger, [FlickrPhotoModel]?) -> Void) -> Void
}

protocol FlickrPhotoLoadImageProtocol: class {
    func loadImageFromUrl(_ url: NSURL, closure: @escaping (UIImage?, NSError?) -> Void)
}

class FlickrDataManager: FlickrPhotoSearchProtocol, FlickrPhotoLoadImageProtocol  {
 
    
    struct Error {
        static let invalidAccessErrorCode = 100
    }
    
    struct FlickrAPI {
        static let APIKey = "65213556f74e846dbf5e6e024ecc680b"
        static let tagSearchFormat = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&page=%i&format=json&nojsoncallback=1"
        static let tagSearchFormat1 = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=65213556f74e846dbf5e6e024ecc680b&tags=nature&page=1&format=json&nojsoncallback=1"
    }
    
    struct FlickrMetaDataKeys {
        static let failureStausCode = "code"
    }
    
    func fetchPhotosForSearchText(searchText: String, page: NSInteger, closure: @escaping (NSError?, NSInteger, [FlickrPhotoModel]?) -> Void) -> Void {
        
        let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let format = FlickrAPI.tagSearchFormat
        let arguments : [CVarArg] = [FlickrAPI.APIKey, escapedSearchText!, page]
        
        let photoURL = String(format: format, arguments)
        
        let url = NSURL(string: FlickrAPI.tagSearchFormat1)
        let request = URLRequest(url: url! as URL)
        let searchTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print ("Error fetchting photos: \(error!)")
                closure(error as NSError?, 0 , nil)
            }
            
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                
                guard let results = resultsDictionary else {return}
                
                if let statusCode = results[FlickrMetaDataKeys.failureStausCode] as? Int {
                    if statusCode == Error.invalidAccessErrorCode {
                        let invalidAccessError = NSError(domain: "FlickrAPIDomain", code: statusCode, userInfo: nil)
                        closure(invalidAccessError, 0, nil)
                        return
                    }
                }
                
                guard let photosContainer = resultsDictionary?["photos"] as? NSDictionary else { return }
                guard let totalPageCountString = photosContainer["total"] as? String else {return}
                guard let totalPageCount = NSInteger(totalPageCountString as String) else {return}
                
                guard let photosArray = photosContainer["photo"] as? [NSDictionary] else {return}
                
                let flickrPhoto : [FlickrPhotoModel] = photosArray.map({ (photoDictionary) -> FlickrPhotoModel  in
                    let photoId = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let server = photoDictionary["server"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    
                    let flickrPhoto = FlickrPhotoModel(photoId: photoId, farm: farm, server: server, title: title, secret: secret)
                    
                    return flickrPhoto

                })

                closure(nil, totalPageCount, flickrPhoto)

                
            } catch let error as NSError {
                print("Error parsing Error: \(error)")
                closure(error as NSError?, 0, nil)
                return
            }
            
        }
        searchTask.resume()
        
    }
    
    //Memory
    
    func loadImageFromUrl(_ url: NSURL, closure: @escaping (UIImage?, NSError?) -> Void) {
        SDWebImageManager.shared().loadImage(with: url as URL, options: .cacheMemoryOnly, progress: nil) { (image, data, error, cache, finished, withUrl) in
            if ((image != nil) && finished) {
                closure(image, error! as NSError)
            }
        }
    }
    
    
}
