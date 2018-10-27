//
//  Model.swift
//  travellling
//
//  Created by Santosh chaurasia on 27/10/18.
//  Copyright © 2018 Santosh chaurasia. All rights reserved.
//

import Foundation

struct flickerPhotoData {
    
    let id :String?
    let owner : String
    let secret :String?
    let server :String?
    let farm : Int
    let title :String
    let ispublic :String
    let isfriend :String
    let isfamily :String
    
    init(id:String? , owner:String = "", secret:String?,farm:Int, server: String? , title: String = "", ispublic:String = "",isfriend:String = "",isfamily: String = ""){
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.ispublic = ispublic
        self.isfriend = isfriend
        self.isfamily = isfamily
        
    }
}
