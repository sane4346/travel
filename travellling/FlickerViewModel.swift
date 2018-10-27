//
//  FlickerViewModel.swift
//  travellling
//
//  Created by Santosh chaurasia on 26/10/18.
//  Copyright © 2018 Santosh chaurasia. All rights reserved.
//

import Foundation
import UIKit

struct cellModel {
    let image : UIImage?
}

class FlickerViewModel {
    var photosCount : Int = 0
    var imagesData : [flickerPhotoData]?
    var images : [UIImage]?
    init() {
        self.photosCount = 100
    }
    func getResultsCount() -> Int
    {
        return photosCount
    }
    func getJSONForImagesData(searchtext:String, complete:@escaping (Bool)->Void)
    {
        if searchtext.count == 0 {
        }
        NetworkManager.shared.sendRequestForImagesData(searchText: searchtext, complete: { photo,status in
            if status == "ok" {
                let data = photo as? [[String:Any]]
                for imageData in data!  {
                        let id = imageData["id"] as? String
                        let secret = imageData["secret"] as? String
                    let farm = imageData["farm"] as! Int
                        let server = imageData["server"] as? String
                        let photomodel = flickerPhotoData (id:id,secret:secret,farm:farm,server:server)
                        self.imagesData?.append(photomodel)
                }
             complete(true)
            }
            complete(false)
        })
    }
    func fetchImagesFromServer() {
        for imagedata in self.imagesData! {
                let id = imagedata.id
                let farm = imagedata.farm
                let secret = imagedata.secret
                let server = imagedata.server
            let urlString = flickerApi.getFLickerImagePathFor(farm: farm, server: server!, id: id!, secret: secret!).path
                let url = URL(string: urlString)
                URLSession.shared.dataTask(with: url!, completionHandler :{ [weak self] (data , response ,error) in
                    // let response = response as? HTTPURLResponse, response.status = 200
                    guard let data = data else {
                        return
                    }
                    let image = UIImage(data: data)
                    self?.images?.append(image!)
                }).resume()
        }
    }
    
    func imageAt(indexPath:IndexPath) -> UIImage?
    {
        if let image = images?[indexPath.row] {
            return image
        }
        return nil
    }
}
