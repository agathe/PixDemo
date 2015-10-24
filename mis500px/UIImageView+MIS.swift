//
//  UIImageView+MIS.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/24/15.
//  Copyright © 2015 Misberri. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func showImage(url: NSURL?, placeholder: String?){
        if let placeholder = placeholder {
            self.image = UIImage(named: placeholder)
        }
        
        if let url = url {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                if error != nil {return }
                if let data = data {
                    let image = UIImage(data: data)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.image = image
                    })
                }
            })
            task.resume()
        }
    }
}