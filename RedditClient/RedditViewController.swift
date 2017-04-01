//
//  ViewController.swift
//  RedditClient
//
//  Created by rcorin on 1/4/17.
//  Copyright © 2017 Moonlighting. All rights reserved.
//

import UIKit

class RedditViewController: UITableViewController {
    private var posts : [ RedditPost ] = []
    private var redditLoader = RedditLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        redditLoader.loadNextPosts { [weak self] newPosts in
            self?.posts.append(contentsOf: newPosts)
            self?.tableView.reloadData()
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RedditTableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedditTableViewCellId", for: indexPath) as! RedditTableViewCell
        cell.titleLabel.text = post.title
        cell.postedByTimeAgoLabel.text = post.author
        cell.commentsNumberLabel.text = String.init(describing: post.comments)
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

