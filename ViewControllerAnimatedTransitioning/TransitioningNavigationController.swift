//
//  TransitioningViewController.swift
//  ViewControllerAnimatedTransitioning
//
//  Created by Dave on 2017. 2. 20..
//  Copyright © 2017년 Yainoma. All rights reserved.
//

import UIKit

class TransitioningNavigationController: UINavigationController {
    
    let expandingTransition = ExpandingAnimatedTransition()
    let contractingTransition = ContractingAnimatedTransition()
    let contractingInteractionTransition = ContractingInteractionTransition()
    
    var interactiveDismissal = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TransitioningNavigationController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let vc = (presented as? TransitioningNavigationController)?.topViewController as? DetailViewController {
            contractingInteractionTransition.viewController = vc
            contractingInteractionTransition.animatedTransition = contractingTransition
        }
        
        let presentedVC = source as? ViewController
        if let selectedIndexPath = presentedVC?.collectionView?.indexPathsForSelectedItems?.first,
            let cell = presentedVC?.collectionView?.cellForItem(at: selectedIndexPath) as? CollectionViewCell {
            expandingTransition.cell = cell
            return expandingTransition
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let vc = (dismissed as? TransitioningNavigationController)?.topViewController as? DetailViewController {
            contractingTransition.imageView = vc.imageView
            return contractingTransition
        }
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveDismissal ? contractingInteractionTransition : nil
    }
}
