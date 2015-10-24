//
//  MISPhotoModel.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/24/15.
//  Copyright © 2015 Misberri. All rights reserved.
//

import UIKit

struct MISPhotoModel {
    let name:String?
    let user: MISUserModel?
    let url: NSURL?
    
    init(name:String?, user:MISUserModel?, surl: String?){
        self.name = name
        self.user = user
        self.url = (surl != nil) ? NSURL(string: surl!) : nil
    }
    
    
}
