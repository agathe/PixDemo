//
//  MISPhotosViewModel.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/24/15.
//  Copyright © 2015 Misberri. All rights reserved.
//
import UIKit



class MISPhotosViewModel: NSObject {
    let apiBaseUrl = "https://api.500px.com/v1/photos" //&image_size[]=2
    let apiBaseParams = ["consumer_key": "vW8Ns53y0F57vkbHeDfe3EsYFCatTJ3BrFlhgV3W",
    "feature": "popular"]
    let apiPhotosName = "photos"
    
    let data = Observable<[MISPhotoModel]>([])
    
    var fetchCount = 20
    var page = 0
    var isLoadingMore = false
    
    var serialQueue:dispatch_queue_t = {
        let serialQueueName = "com.misberri.500px.serialqueue"
        return dispatch_queue_create(serialQueueName, DISPATCH_QUEUE_SERIAL)
    }()
    
    func fetchNextPhotos(){
        dispatch_async(serialQueue) { () -> Void in
            self.isLoadingMore = true
            let url = self.serviceUrl(page: self.page + 1, count: self.fetchCount) as NSURL!
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
                        self.page += 1
                    }
                }
                // TODO update page
                self.isLoadingMore = false
            })
            task.resume()
        }
    }
    
    func serviceUrl(page page: Int, count: Int) -> NSURL? {
        var params = apiBaseParams
        params["image_size[]"] = "3"
        params["rpp"] = "\(count)"
        params["page"] = "\(page)"
        var paramQuery = "?"
        for (k,v) in params{
            paramQuery += "\(k)=\(v)&"
        }
        let url = NSURL(string: apiBaseUrl.stringByAppendingString(paramQuery))
        return url
    }
    
    func deserializePhotos(jsonDict: NSDictionary) -> [MISPhotoModel] {
        if jsonDict.count == 0 {return []}
        
        var data : [MISPhotoModel] = []
        
        let photos = jsonDict[apiPhotosName] as? NSArray
        if let photos = photos {
            for photoDict in photos {
                let name = photoDict["name"] as? String
                let urlObject = photoDict["image_url"]
                var url: String?
                switch urlObject {
                case let obj as String:
                    url = obj
                case let obj as [String]:
                    url = obj[0]
                default:
                    url = nil
                }
                
                
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
    
    func needsMoreData(lastShownIndex: NSIndexPath?) -> Bool {
        guard let lastShownIndex = lastShownIndex else {return false}
        return lastShownIndex.row >= self.data.get().count - 5 && !self.isLoadingMore
    }
    
}