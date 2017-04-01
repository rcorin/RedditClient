//
//  RedditLoader.swift
//  RedditClient
//
//  Created by rcorin on 1/4/17.
//  Copyright © 2017 Moonlighting. All rights reserved.
//

// A class for loading posts from reddit API, paginated

import UIKit

class RedditLoader: NSObject, NSCoding {
    // keep track of last loaded page, for pagination
    private var after : String = ""

    override init() {
        after = ""
    }

    // load posts from Reddit top.json
    func loadNextPosts(_ completionHandler : @escaping ([RedditPost])->() ) {
        let urlString = String.init(format: "https://www.reddit.com/top.json?after=%@", after)
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error ?? "Unknown error.")
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    
                    guard let dataDict = parsedData["data"] as? [String:Any] else { return }
                    
                    guard let children = dataDict["children"] as? [[String:Any]] else { return }
                    
                    var posts : [RedditPost] = []
                    
                    if let nAfter = dataDict["after"] as? String {
                        self.after = nAfter
                    }
                    
                    for child in children {
                        let post = RedditPost()
                        guard let childData = child["data"] as? [String:Any] else { continue }
                        post.author = childData["author"] as? String
                        post.title =  childData["title"] as? String
                        post.comments = childData["num_comments"] as? Int
                        post.thumbUrl = childData["thumbnail"] as? String
                        let domain = childData["domain"] as? String
                        if let urlString = childData["url"] as? String {
                            if domain?.range(of: "i.imgur.com") != nil && urlString.hasSuffix(".jpg"){
                                post.imgUrl = urlString
                            }
                        }
                        if let dateNumber = childData["created_utc"] as? TimeInterval {
                            post.created = dateNumber
                        }
                        posts.append(post)
                    }
                    DispatchQueue.main.async {
                        completionHandler(posts)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        
    }
    
    //MARK: - state restoration/preservation
    struct PropertyKey {
        static let after = "after"
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(after, forKey: PropertyKey.after)
    }
    
    required init?(coder aDecoder: NSCoder) {
        after = aDecoder.decodeObject(forKey: PropertyKey.after) as! String
    }
}
