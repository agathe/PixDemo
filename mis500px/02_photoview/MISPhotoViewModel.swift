//
//  MISPhotoViewModel.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/25/15.
//  Copyright © 2015 Misberri. All rights reserved.
//

import UIKit

class MISPhotoViewModel: NSObject {
    
    let photo: MISPhotoModel
    let image: UIImage

    init(_ photo: MISPhotoModel, _ image:UIImage) {
        self.photo = photo
        self.image = image
        super.init()
    }
    
}
