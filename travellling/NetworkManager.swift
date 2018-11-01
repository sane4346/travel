//
//  NetworkManager.swift
//  travellling
//
//  Created by Santosh chaurasia on 27/10/18.
//  Copyright © 2018 Santosh chaurasia. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    var imagesResult : [flickerPhotoData]?
    let path = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text="
    
    override init()
    {
        
    }
    
    func sendRequestForImagesData(searchText:String, complete: @escaping (Any?)->(Void)){
        
        let urlRequest = self.path + searchText
        guard let url = URL(string: urlRequest) else {
            complete(nil)
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler :{ (data , response ,error) in
            if let _ = error {
                complete(nil)
            }
            guard let data = data,
                let jsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as! NSDictionary,
                let status = jsonData.value(forKey: "stat") as? String ,
                let photos = jsonData.value(forKey: "photos") as? NSDictionary,
                let photo = photos.value(forKey: "photo") else {
                    complete(nil)
                    return
            }
            if( status == "ok") {
                complete(photo)
            } else {
                complete(nil)
            }
        }).resume()
    }
}

enum flickerApi  {
    //   "http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg"
    static let imagePath = "http://farm%@.static.flickr.com/%@/%@_%@.jpg"
    case getFLickerImagePathFor(farm:String,server:String,id:String,secret:String)
    
    var path : String {
        switch self {
        case let .getFLickerImagePathFor(farm,server,id,secret):
            return String(format: flickerApi.imagePath, farm,server,id,secret)
        }
    }
}
