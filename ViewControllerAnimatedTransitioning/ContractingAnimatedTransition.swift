//
//  ContractingTransition.swift
//  ViewControllerAnimatedTransitioning
//
//  Created by Dave on 2017. 2. 16..
//  Copyright © 2017년 Yainoma. All rights reserved.
//

import UIKit

class ContractingAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var imageView: UIImageView?
    
    private let duration = 0.37
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let imageView = imageView,
            let toNavi = transitionContext.viewController(forKey: .to) as? UINavigationController,
            let toController = toNavi.topViewController as? ViewController,
            let fromController = (transitionContext.viewController(forKey: .from) as? TransitioningNavigationController)?.topViewController as? DetailViewController,
            let toCell = toController.collectionView?.cellForItem(at: fromController.indexPath!) as? CollectionViewCell else { return }
        
        let contractingView = UIImageView(image: imageView.image)
        contractingView.contentMode = toCell.imageView.contentMode
        contractingView.clipsToBounds = true
        contractingView.frame = contractionViewRect(from: fromController)
        
        transitionContext.containerView.addSubview(contractingView)
        
        toCell.alpha = 0.0
        toNavi.view.alpha = 0.0
        fromController.imageView.alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            contractingView.frame = self.contractionViewRect(to: toController, to: toCell)
            toNavi.view.alpha = 1.0
            fromController.view.alpha = 0.0
        }) { (finished) in
            contractingView.removeFromSuperview()
            toCell.alpha = 1.0
            
            transitionContext.completeTransition(finished)
        }
    }
    
    private func contractionViewRect(from viewController: DetailViewController) -> CGRect {
        return viewController.imageView.frame
    }
    
    private func contractionViewRect(to viewController: ViewController, to cell: CollectionViewCell) -> CGRect {
        let origin = CGPoint(x: cell.frame.origin.x,
                             y: cell.frame.origin.y - viewController.collectionView!.contentOffset.y)
        return CGRect(origin: origin, size: cell.frame.size)

    }
}
