//
//  ViewController.swift
//  ViewControllerAnimatedTransitioning
//
//  Created by Dave on 2017. 2. 16..
//  Copyright © 2017년 Yainoma. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    fileprivate let images = [UIImage(named: "image00"),
                              UIImage(named: "image01"),
                              UIImage(named: "image02"),
                              UIImage(named: "image03"),
                              UIImage(named: "image04"),
                              UIImage(named: "image00"),
                              UIImage(named: "image01"),
                              UIImage(named: "image02"),
                              UIImage(named: "image03"),
                              UIImage(named: "image04"),
                              UIImage(named: "image00"),
                              UIImage(named: "image01"),
                              UIImage(named: "image02"),
                              UIImage(named: "image03"),
                              UIImage(named: "image04")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        func index(for cell: UICollectionViewCell) -> Int? {
            let position = cell.convert(CGPoint.zero, to: collectionView)
            return collectionView?.indexPathForItem(at: position)?.item
        }
        
        if let navi = segue.destination as? UINavigationController,
            let vc = navi.topViewController as? DetailViewController {
            guard let selectedIndexPath = collectionView?.indexPathsForSelectedItems?.first else { return }
            
            vc.image = images[selectedIndexPath.item]
            vc.indexPath = selectedIndexPath
        }
    }

}

extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = images[indexPath.item]
        
        return cell
    }
}


class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
}
