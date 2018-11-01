//
//  FlickerCollectionViewCell.swift
//  travellling
//
//  Created by Santosh chaurasia on 27/10/18.
//  Copyright © 2018 Santosh chaurasia. All rights reserved.
//

import UIKit

class FlickerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var flickerCellImage: customeUIImageView!
    
    
    func configure(photoData : flickerPhotoData) {
        flickerCellImage.downloadImageFromUrl(for: photoData)
    }
    
}


let imageCache = NSCache<AnyObject, UIImage>()

class customeUIImageView: UIImageView {
    
    var imageUrlString : String?
    
    func downloadImageFromUrl( for photoData : flickerPhotoData, defaultImage: UIImage? = UIImage(named: "uber")) {
        let id = photoData.id
        let farm = String(photoData.farm)
        let secret = photoData.secret
        let server = photoData.server
        let urlString = flickerApi.getFLickerImagePathFor(farm: farm, server: server!, id: id!, secret: secret!).path
        
        self.imageUrlString = urlString
        //image chache check before hitting server
        image = defaultImage
        if let imageFromChache = imageCache.object(forKey: urlString as AnyObject) {
                self.image = imageFromChache
                return
        }
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url, completionHandler :{ [weak self ] (data , response ,error) in
                guard let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                    let data = data else { return }
                
                DispatchQueue.main.async {
                    if let imageToChache = UIImage(data: data) {
                        if self?.imageUrlString == urlString {
                            self?.image = imageToChache
                        }
                        imageCache.setObject(imageToChache, forKey: urlString as AnyObject)
                    }
                }
                
            }).resume()
        }
}
