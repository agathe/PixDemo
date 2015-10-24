//
//  MISPhotosViewModel.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/24/15.
//  Copyright © 2015 Misberri. All rights reserved.
//
import UIKit



class MISPhotosViewModel: NSObject {
    let baseUrl = "https://api.500px.com/v1/photos?feature=popular&consumer_key=vW8Ns53y0F57vkbHeDfe3EsYFCatTJ3BrFlhgV3W" //&image_size[]=2
    let apiPhotosName = "photos"
    
    let data = Observable<[MISPhotoModel]>([])
    
    var fetchCount = 10
    var offset = 0
    var serialQueue:dispatch_queue_t = {
        let serialQueueName = "com.misberri.500px.serialqueue"
        return dispatch_queue_create(serialQueueName, DISPATCH_QUEUE_SERIAL)
    }()
    
    func fetchNextPhotos(){
        dispatch_async(serialQueue) { () -> Void in
            let url = self.serviceUrl(offset: 0, count: 20) as NSURL!
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                if error != nil {return }
                if let data = data {
                    let jsonDict: NSDictionary?
                    do {
                        try jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                    } catch {
                        jsonDict = nil
                    }
                    if let jsonDict = jsonDict {
                        let photos = self.deserializePhotos(jsonDict)
                        let all = self.data.get() + photos
                            self.data.set(all)
                    }
                }
            })
            task.resume()
        }
    }
    
    func serviceUrl(offset offset: Int, count: Int) -> NSURL? {
        return NSURL(string: baseUrl)
    }
    
    func deserializePhotos(jsonDict: NSDictionary) -> [MISPhotoModel] {
        if jsonDict.count == 0 {return []}
        
        var data : [MISPhotoModel] = []
        
        let photos = jsonDict[apiPhotosName] as? NSArray
        if let photos = photos {
            for photoDict in photos {
                let name = photoDict["name"] as? String
                let url = photoDict["image_url"] as? String
                
                let userDict = photoDict["user"] as? NSDictionary
                
                var user: MISUserModel?
                
                if let userDict = userDict {
                    let firstname = userDict["firstname"] as? String
                    let lastname = userDict["lastname"] as? String
                    let userUrl = userDict["userpic_url"] as? String
                    user = MISUserModel(firstname, lastname, userPicUrl: userUrl)
                } else {
                    user = nil
                }
                
                let photo = MISPhotoModel(name: name, user: user, surl: url)
                data.append(photo)
            }
            
        }
        
        return data
    }
    
}