//
//  MISUserModel.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/24/15.
//  Copyright © 2015 Misberri. All rights reserved.
//

import UIKit

struct MISUserModel {
    let firstname:String?
    let lastname: String?
    let userpicUrl: NSURL?
    
    var name:String {
        get{
            if firstname != nil && lastname != nil {
                return "\(firstname!) \(lastname!)"
            } else if firstname != nil {
                return firstname!
            } else if lastname != nil {
                return lastname!
            }
            return ""
        }
    }
    
    init(_ firstname:String?, _ lastname:String?, userPicUrl:String?) {
        self.firstname = firstname
        self.lastname = lastname
        self.userpicUrl = (userPicUrl != nil) ? NSURL(string: userPicUrl!) : nil
    }
    
}
 