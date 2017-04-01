//
//  RedditDisplayImageViewController.swift
//  RedditClient
//
//  Created by rcorin on 1/4/17.
//  Copyright © 2017 Moonlighting. All rights reserved.
//

import UIKit

class DisplayImageViewController: UIViewController {
    var urlString : String? = ""
    var titleString : String? = ""

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        loadImage()
        
        self.title = titleString
        self.saveButton.isEnabled = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

    @IBAction func onClickSaveButton(_ sender: Any) {
    }
    
    func loadImage(){
        if let urlString = self.urlString {
            imageView.downloadedFrom(link: urlString, contentMode: .scaleAspectFit)
        }
    }
   
}
