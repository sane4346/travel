//
//  FlickerCollectionViewCell.swift
//  travellling
//
//  Created by Santosh chaurasia on 27/10/18.
//  Copyright © 2018 Santosh chaurasia. All rights reserved.
//

import UIKit

class FlickerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var flickerCellImage: UIImageView!
    
    
    func configure(photoData : flickerPhotoData) {
        flickerCellImage.downloadImageFromUrl(for: photoData)
    }
    
}


extension UIImageView {
    
    func downloadImageFromUrl( for photoData : flickerPhotoData, defaultImage: UIImage? = UIImage(named: "uber")) {
        let id = photoData.id
        let farm = String(photoData.farm)
        let secret = photoData.secret
        let server = photoData.server
        let urlString = flickerApi.getFLickerImagePathFor(farm: farm, server: server!, id: id!, secret: secret!).path
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler :{ [weak self ] (data , response ,error) in
            guard let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                let data = data else { return }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
            else {
                self?.image = defaultImage
            }
        }).resume()
    }
    
}
