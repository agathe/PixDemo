//
//  String+MIS.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/24/15.
//  Copyright © 2015 Misberri. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func mis_title() -> NSAttributedString {
        let titleFont = UIFont(name: "HelveticaNeue-Medium ", size: 16) ?? UIFont.systemFontOfSize(16)
        let attributes = [
            NSFontAttributeName: titleFont,
            NSBackgroundColorAttributeName: UIColor.blackColor().colorWithAlphaComponent(0.2)
        ]
        
        let transparentAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor().colorWithAlphaComponent(0.0),
            NSBackgroundColorAttributeName: UIColor.blackColor().colorWithAlphaComponent(0.2)
        ]
        
        
        let attString = NSMutableAttributedString(string: "  \(self)", attributes: attributes)
        attString.appendAttributedString(NSAttributedString(string:"..", attributes: transparentAttributes))
        return attString
    }
    
}