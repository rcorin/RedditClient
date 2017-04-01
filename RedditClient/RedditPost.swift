//
//  RedditPost.swift
//  RedditClient
//
//  Created by rcorin on 1/4/17.
//  Copyright © 2017 Moonlighting. All rights reserved.
//

//  Reddit Post data model -- much other info in JSON ignored!

import UIKit

class RedditPost: NSObject, NSCoding {
    var title : String? = ""
    var author : String? = ""
    var comments : Int? = 0
    var created : TimeInterval? = 0
    var thumbUrl : String? = ""
    var imgUrl : String? = ""

    override init() {
        self.title = ""
        self.author = ""
        self.comments = 0
        self.created = 0
        self.thumbUrl = ""
        self.imgUrl = ""
    }

    //MARK: Encoding for state preservation/restoration
    struct PropertyKey {
        static let title = "title"
        static let author = "author"
        static let comments = "comments"
        static let created = "created"
        static let thumbUrl = "thumbUrl"
        static let imgUrl = "imgUrl"
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: PropertyKey.title)
        aCoder.encode(self.author, forKey: PropertyKey.author)
        aCoder.encode(self.comments, forKey: PropertyKey.comments)
        aCoder.encode(self.created, forKey: PropertyKey.created)
        aCoder.encode(self.thumbUrl, forKey: PropertyKey.thumbUrl)
        aCoder.encode(self.imgUrl, forKey: PropertyKey.imgUrl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String
        self.author = aDecoder.decodeObject(forKey: PropertyKey.author) as? String
        self.comments = aDecoder.decodeObject(forKey: PropertyKey.comments) as? Int
        self.created = aDecoder.decodeObject(forKey: PropertyKey.created) as? TimeInterval
        self.thumbUrl = aDecoder.decodeObject(forKey: PropertyKey.thumbUrl) as? String
        self.imgUrl = aDecoder.decodeObject(forKey: PropertyKey.imgUrl) as? String
    }

}
