//
//  RedditTableViewCell.swift
//  RedditClient
//
//  Created by rcorin on 1/4/17.
//  Copyright © 2017 Moonlighting. All rights reserved.
//

import UIKit

class RedditTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postedByTimeAgoLabel: UILabel!
    @IBOutlet weak var commentsNumberLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    var post : RedditPost? = nil {
        didSet {
            if let aPost = post {
                self.setupCell(post: aPost)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    private func setupCell (post:RedditPost){
        self.thumbImageView.image = UIImage.init(named: "AppIcon60x60")
        self.titleLabel.text = post.title
        var timeAgo = ""
        if let created = post.created {
            timeAgo = (Date.init().timeIntervalSince1970 - created).format()
        }
        
        let postedBy = post.author ?? ""
        
        if (timeAgo != "") || (postedBy != "" ) {
            self.postedByTimeAgoLabel.text = String.init(format: "%@%@", timeAgo, postedBy=="" ? "" : String.init(format: " by %@", postedBy))
        }
        
        let nc = post.comments ?? 0
        self.commentsNumberLabel.text = String.init(format: "%@ comments", nc>0 ? String(nc) : "no" )
        
        if let thumbUrl = post.thumbUrl {
            self.thumbImageView.downloadedFrom(link: thumbUrl)
        }
        
        self.accessoryType = post.imgUrl != "" ? .disclosureIndicator : .none
        self.isUserInteractionEnabled = post.imgUrl != ""
        self.selectionStyle = .none
    }

}

extension TimeInterval {
    func format() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        let fmtstr = String.init(format: "%@ ago", formatter.string(from: self)!)
        return fmtstr
    }
}

extension UIImageView {
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        UIImage.downloadedFrom(link: link, completionHandler:{ image in
            self.image = image
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        })
        
    }
}

extension UIImage {
    static func downloadedFrom(link: String, completionHandler : @escaping (UIImage?) -> () ) {
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else { return }
            DispatchQueue.main.async() {
                completionHandler( UIImage(data: data) )
            }
            
            }.resume()
    }
}
