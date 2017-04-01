//
//  ViewController.swift
//  RedditClient
//
//  Created by rcorin on 1/4/17.
//  Copyright © 2017 Moonlighting. All rights reserved.
//

//  A class for displaying reddit posts in a table.
//  Posts with images can be tapped and sent to display the image in fullscreen.

import UIKit

class RedditViewController: UITableViewController {
    private var posts : [ RedditPost ] = []
    private var redditLoader = RedditLoader()
    private var isLoading = false
    
    //MARK: TableView data source and delegate
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
        cell.post = post
        
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Start paginating when we're 5 posts away to the last one
        if indexPath.row>=posts.count-5 {
            if !isLoading {
                self.startLoading()
                redditLoader.loadNextPosts { [weak self] newPosts in
                    self?.posts.append(contentsOf: newPosts)
                    self?.tableView.reloadData()
                    self?.stopLoading()
                }
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? RedditTableViewCell {
            if let destViewController = segue.destination as? DisplayImageViewController {
                destViewController.urlString = cell.post?.imgUrl
                destViewController.titleString = cell.post?.title
            }
        }
     }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - auxiliary functions
    func startLoading()
    {
        self.isLoading = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func stopLoading()
    {
        self.isLoading = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: - State preservation / restoration
    struct PropertyKey {
        static let posts = "posts"
        static let loader = "loader"
        static let offset = "offset"
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(posts, forKey: PropertyKey.posts)
        coder.encode(redditLoader, forKey: PropertyKey.loader)
        coder.encode(self.tableView.contentOffset, forKey: PropertyKey.offset)
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        if let savedLoader = coder.decodeObject(forKey: PropertyKey.loader) as? RedditLoader {
            redditLoader = savedLoader
        }
        if let savedPosts = coder.decodeObject(forKey: PropertyKey.posts) as? [RedditPost] {
            posts = savedPosts
            self.tableView.reloadData()
        }
        if let savedOffset = coder.decodeObject(forKey: PropertyKey.offset) as? String {
            let offset = CGPointFromString(savedOffset)
            self.tableView.setContentOffset(offset, animated: false)
        }
        
    }
    
    override func applicationFinishedRestoringState() {
        super.applicationFinishedRestoringState()
        
    }
}

