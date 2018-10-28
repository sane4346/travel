//
//  FlickerViewModel.swift
//  travellling
//
//  Created by Santosh chaurasia on 27/10/18.
//  Copyright © 2018 Santosh chaurasia. All rights reserved.
//

import Foundation
import UIKit

struct cellModel {
    let image : UIImage?
}

class FlickerViewModel  {
    var photosCount : Int = 0
    var photosData = [flickerPhotoData]()
    
    init() {
        //self.photosCount = 0
    }
    func setItemCount (items:Int)
    {
         self.photosCount = items
    }
    func getJSONForImagesData(searchtext:String, complete:@escaping (Bool)->Void)
    {
        NetworkManager.shared.sendRequestForImagesData(searchText: searchtext, complete: { photo in
            guard let photoData = photo as? [[String:Any]] else {
                complete(false)
                return
            }
            var pData = [flickerPhotoData]()
            for imageData in photoData  {
                let id = imageData["id"] as? String
                let secret = imageData["secret"] as? String
                let farm = imageData["farm"] as! Int
                let server = imageData["server"] as? String
                let photomodel = flickerPhotoData (id:id,secret:secret,farm:farm,server:server)
                pData.append(photomodel)
            }
            self.photosData = pData
            self.setItemCount(items: self.photosData.count)
            complete(true)
        })
    }
    
    func photoDataAt(indexPath:IndexPath) -> flickerPhotoData?
    {
        if indexPath.row >= 0 && indexPath.row < photosCount {
            return photosData[indexPath.row]
        }
        return nil
        
    }
}
