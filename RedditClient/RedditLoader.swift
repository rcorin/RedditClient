//
//  RedditLoader.swift
//  RedditClient
//
//  Created by rcorin on 1/4/17.
//  Copyright © 2017 Moonlighting. All rights reserved.
//

import UIKit

class RedditLoader: AnyObject {
    func loadNextPosts(_ completionHandler : @escaping ([RedditPost])->() ) {
        // let's fake some posts
        
        var posts : [RedditPost] = []

        let aPost = RedditPost()
        aPost.author = "John Silver"
        aPost.comments = 12
        aPost.created = 100
        aPost.imgUrl = ""
        aPost.title = "This is a test post"

        let anotherPost = RedditPost()
        anotherPost.author = "John Silver"
        anotherPost.comments = 12
        anotherPost.created = 100
        anotherPost.imgUrl = ""
        anotherPost.title = "This is a test post"

        posts.append(aPost)
        posts.append(anotherPost)
        
        DispatchQueue.main.async {
            completionHandler(posts)
        }

    }
}
