//
//  DetailViewController.swift
//  ViewControllerAnimatedTransitioning
//
//  Created by Dave on 2017. 2. 16..
//  Copyright © 2017년 Yainoma. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


