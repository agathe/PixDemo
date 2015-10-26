//
//  MISPhotosViewModel.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/24/15.
//  Copyright © 2015 Misberri. All rights reserved.
//
import UIKit

let numberOfPhotosForFilter = 50

class MISPhotosViewModel: NSObject {
    let apiBaseUrl = "https://api.500px.com/v1/photos"
    let apiBaseParams = ["consumer_key": "vW8Ns53y0F57vkbHeDfe3EsYFCatTJ3BrFlhgV3W",
    "feature": "popular"]
    let apiPhotosName = "photos"
    
    // Output
    let data = Observable<[MISPhotoModel]>([])
    let isLoadingMore = Observable<Bool>(false)
    
    // Input
    let searchQuery = Observable<String?>(nil)
    
    // pagination
    private var fetchCount = 25
    private var page = 0
    
    
    private var serialQueue:dispatch_queue_t = {
        let serialQueueName = "com.misberri.500px.serialqueue"
        return dispatch_queue_create(serialQueueName, DISPATCH_QUEUE_SERIAL)
    }()
    
    
    // MARK: Data
    
    func fetchNextPhotos() {
        self.fetchNextPhotos(false)
    }
    
    func fetchNextPhotos(reset: Bool) {
        dispatch_async(serialQueue) { () -> Void in
            self.isLoadingMore.set(true)
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
                        var all = !reset ? self.data.get() + photos : photos

                        if self.hasQuery() {
                            all = self.filterPhotos(all, query: self.searchQuery.get())
                        }
                        
                        self.data.set(all)
                        self.page += 1
                    }
                }
                self.isLoadingMore.set(false)
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
    
    private func deserializePhotos(jsonDict: NSDictionary) -> [MISPhotoModel] {
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
        let count = self.count()
        let hasQuery = self.hasQuery()
        return !self.isLoadingMore.get()
            && !hasQuery
            && lastShownIndex.row >= count - 5
    }

    func count() -> Int {
        return self.data.get().count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    // MARK: filtering
    
    private func filterPhotos(photos:[MISPhotoModel], query: String?) -> [MISPhotoModel] {
        guard let query = query else { return photos }
        
        let filteredPhotos = photos.filter({photo in
            let s:String? = photo.name?.lowercaseString
            if let s = s {
                return s.rangeOfString(query.lowercaseString) != nil
            }
            return true
        })
        return filteredPhotos
    }
    
    private func hasQuery() -> Bool {
        return self.searchQuery.get() != nil
    }
    
    func setQuery(text: String?) {
        if let text = text {
            let query:String = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let searchQuery:String? = query.characters.count > 0 ? query : nil
            self.searchQuery.set(searchQuery)
        } else {
            self.searchQuery.set(nil)
        }
        self.page = 0
        self.fetchNextPhotos(true)
    }
    
    func resetQuery() {
        self.searchQuery.set(nil)
        self.page = 0
        self.fetchNextPhotos(true)
    }
   
    
}