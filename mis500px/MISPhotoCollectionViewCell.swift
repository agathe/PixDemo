//
//  MISPhotoCollectionViewCell.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/24/15.
//  Copyright © 2015 Misberri. All rights reserved.
//

import UIKit
import CoreGraphics

class MISPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var userLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func prepareForReuse() {
        self.userImageView.layer.cornerRadius = self.userImageView.bounds.width / 2 ?? 30
    }
    
    func setDataObject(photo: MISPhotoModel) {
        self.userImageView.layer.cornerRadius = self.userImageView.bounds.width / 2 ?? 30
        self.userImageView.clipsToBounds = true
        
        self.titleLabel.attributedText = photo.name?.mis_title() ?? "".mis_title()
        if let name = photo.user?.name {
            self.userLabel.text = "by \(name.capitalizedString)"
        } else {
            self.userLabel.text = "by unknown"
        }
        
        self.imageView.showImage(photo.url, placeholder: "imagePlaceholder")
        self.userImageView.showImage(photo.user?.userpicUrl, placeholder: "userPlaceholder")
        
        self.titleLabel.sizeToFit()
        self.userLabel.sizeToFit()
    }
    
}
