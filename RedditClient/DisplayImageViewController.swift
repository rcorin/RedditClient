//
//  RedditDisplayImageViewController.swift
//  RedditClient
//
//  Created by rcorin on 1/4/17.
//  Copyright © 2017 Moonlighting. All rights reserved.
//

//  This class is in charge of displaying a given URL image for a Reddit post

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
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(resultSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
        
        self.saveButton.isEnabled = false
    }
    
    func resultSaveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image saved to Gallery", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func loadImage(){
        if let urlString = self.urlString {
            imageView.downloadedFrom(link: urlString, contentMode: .scaleAspectFit)
        }
    }
   
}
