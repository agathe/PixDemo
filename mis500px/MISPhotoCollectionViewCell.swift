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
    @IBOutlet var titleTopConstraint: NSLayoutConstraint!
    
    var setupDone = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView() {
        self.userImageView.layer.cornerRadius = self.userImageView.bounds.width / 2 ?? 30
        self.userImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        if !self.setupDone {
            self.setupView()
            self.setupDone = true
        }
        
        self.userLabel.text = nil
        self.titleLabel.text = nil
        self.userImageView.image = nil
        self.imageView.image = nil
        
        self.setFirstCell(false)
    }
    
    func setDataObject(photo: MISPhotoModel) {
        
        
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
    
    func setFirstCell(bool:Bool){
        self.titleTopConstraint.constant = bool ? 16 + 44 : 16
    }
}
