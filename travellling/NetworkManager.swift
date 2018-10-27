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
    var pages = 0
    override init()
    {
        
    }
    
    func sendRequestForImagesData(searchText:String, complete: @escaping (Any?,String)->(Void)){
        
        let urlRequest = self.path + searchText
        guard let url = URL(string: urlRequest) else {
            complete(nil,"Url_Error")
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler :{ [weak self ] (data , response ,error) in
            guard let data = data else {
                complete(nil,"wrongResponse")
                return
            }
            let jsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as! NSDictionary
            let status = jsonData?.value(forKey: "stat") as? String
            if status == "ok" {
                let photos = jsonData?.value(forKey: "photos") as? NSDictionary
                let photo = photos?.value(forKey: "photo") //as! [[String : Any]]
                self?.pages = photos?.value(forKey: "pages") as! Int
//                for imageData in photo {
//                    if let id = imageData["id"] as? String,
//                        let secret = imageData["secret"] as? String,
//                        let farm = imageData["farm"] as? String,
//                        let server = imageData["server"] as? String {
//                        self?.imagesResult?.append(flickerPhotoData(id:id,secret:secret,farm:farm,server:server))
//                    }
//                }
                complete(photo,status ?? "ok")
            }
            else {
                complete(nil,status!)
            }
        }).resume()
    }
    
    func getImageFor(id:String,secret:String,farm:String,server:String, complete :@escaping (UIImage) -> Void )
    {
        
        
    }
    
}

enum flickerApi  {
    //   "http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg"
    static let imagePath = "http://farm%@.static.flickr.com/%@/%@_%@.jpg"
    case getFLickerImagePathFor(farm:Int,server:String,id:String,secret:String)
    
    var path : String {
        switch self {
        case let .getFLickerImagePathFor(farm,server,id,secret):
            return String(format: flickerApi.imagePath, farm,server,id,secret)
        }
    }
}
